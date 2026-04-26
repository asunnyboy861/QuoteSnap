import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            QuoteListView()
                .tabItem {
                    Label("Quotes", systemImage: "doc.text.fill")
                }
                .tag(0)

            InvoiceListView()
                .tabItem {
                    Label("Invoices", systemImage: "doc.on.doc.fill")
                }
                .tag(1)

            ClientListView()
                .tabItem {
                    Label("Clients", systemImage: "person.2.fill")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.trustBlue)
    }
}
