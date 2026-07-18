import Foundation
import SwiftUI

/// The heart of the app's data persistence.
///
/// `QuoteStore` keeps every quote in memory (the `quotes` array) AND keeps a
/// mirror copy on disk so the data survives quitting the app.
///
/// How the persistence works, start to finish:
///  1. All quotes live in the `quotes` array.
///  2. `didSet` fires every time that array changes (add / edit / delete) and
///     calls `save()`, which encodes the array to JSON and writes it to a file.
///  3. The file lives at `<App Documents folder>/quotes.json`. The Documents
///     folder is private to this app and is backed up / persisted by iOS.
///  4. When the app launches, `init()` calls `load()`, which reads that same
///     file back off disk and decodes the JSON into the `quotes` array.
///
/// That's the whole trick: the array is the "live" data, the JSON file is the
/// durable copy, and we sync them on every change and on every launch.
@MainActor
final class QuoteStore: ObservableObject {

    /// The in-memory list of quotes. Writing to it automatically saves to disk.
    @Published var quotes: [Quote] = [] {
        didSet { save() }
    }

    /// The on-disk location: <App Documents>/quotes.json
    private let fileURL: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)[0]
        return documents.appendingPathComponent("quotes.json")
    }()

    init() {
        load()
    }

    // MARK: - Create / Read / Update / Delete

    func add(text: String, author: String) {
        let quote = Quote(text: text.trimmed, author: author.trimmed)
        quotes.insert(quote, at: 0) // newest first
    }

    func update(_ quote: Quote, text: String, author: String) {
        guard let index = quotes.firstIndex(where: { $0.id == quote.id }) else { return }
        quotes[index].text = text.trimmed
        quotes[index].author = author.trimmed
    }

    /// Delete via swipe-to-delete in a List.
    func delete(at offsets: IndexSet) {
        quotes.remove(atOffsets: offsets)
    }

    /// Delete a specific quote (used by the Delete button in the editor).
    func delete(_ quote: Quote) {
        quotes.removeAll { $0.id == quote.id }
    }

    // MARK: - Disk

    /// Encode the quotes to JSON and write them to disk.
    private func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // human-readable file
            let data = try encoder.encode(quotes)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("QuoteStore: failed to save — \(error)")
        }
    }

    /// Read the JSON file back and decode it into `quotes`.
    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            quotes = try JSONDecoder().decode([Quote].self, from: data)
        } catch {
            // No file yet (first launch) or unreadable — just start empty.
            quotes = []
        }
    }
}

private extension String {
    /// Trim surrounding whitespace/newlines so we don't store blank padding.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
