import Foundation

/// One saved quote.
///
/// - `Codable` lets us convert a quote to/from JSON so it can be written to disk.
/// - `Identifiable` gives each quote a stable `id`, which SwiftUI lists use to
///   track rows as they are added, edited, and deleted.
struct Quote: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var text: String
    var author: String
    var dateSaved: Date = Date()
}
