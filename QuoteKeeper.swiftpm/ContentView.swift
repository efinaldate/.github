import SwiftUI

/// Describes what the editor sheet is doing: adding a new quote, or editing
/// an existing one. `Identifiable` lets us drive `.sheet(item:)` with it.
enum EditorState: Identifiable {
    case new
    case edit(Quote)

    var id: String {
        switch self {
        case .new:            return "new"
        case .edit(let quote): return quote.id.uuidString
        }
    }
}

/// The main screen: a list of saved quotes with add / edit / delete.
struct ContentView: View {
    @EnvironmentObject private var store: QuoteStore
    @State private var editorState: EditorState?

    var body: some View {
        NavigationStack {
            Group {
                if store.quotes.isEmpty {
                    emptyState
                } else {
                    quoteList
                }
            }
            .navigationTitle("Quotes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        editorState = .new
                    } label: {
                        Label("Add Quote", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $editorState) { state in
                EditQuoteView(state: state)
            }
        }
    }

    private var quoteList: some View {
        List {
            ForEach(store.quotes) { quote in
                Button {
                    editorState = .edit(quote)   // tap a row to edit it
                } label: {
                    QuoteRow(quote: quote)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: store.delete)      // swipe left to delete
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Quotes Yet", systemImage: "quote.bubble")
        } description: {
            Text("Tap + to save your first quote. It will still be here after you quit the app.")
        }
    }
}

/// A single row in the list.
struct QuoteRow: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\u{201C}\(quote.text)\u{201D}")
                .font(.body)
            if !quote.author.isEmpty {
                Text("— \(quote.author)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
