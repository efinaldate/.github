import SwiftUI

/// App entry point.
///
/// The `QuoteStore` is created once here with `@StateObject` (so it lives for
/// the whole app session) and shared with every view via `.environmentObject`.
@main
struct QuoteKeeperApp: App {
    @StateObject private var store = QuoteStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
