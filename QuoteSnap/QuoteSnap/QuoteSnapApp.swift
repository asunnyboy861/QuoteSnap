import SwiftUI
import SwiftData

@main
struct QuoteSnapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Quote.self, Invoice.self, Client.self, BusinessInfo.self])
    }
}
