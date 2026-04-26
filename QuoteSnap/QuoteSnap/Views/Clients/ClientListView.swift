import SwiftUI
import SwiftData

struct ClientListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Client.name) private var clients: [Client]
    @State private var searchText = ""
    @State private var showAddClient = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredClients) { client in
                    NavigationLink(destination: ClientFormView(client: client)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(client.name)
                                .font(.body)
                                .foregroundColor(.textPrimary)
                            if !client.company.isEmpty {
                                Text(client.company)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            if !client.email.isEmpty {
                                Text(client.email)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteClients)
            }
            .searchable(text: $searchText, prompt: "Search clients...")
            .navigationTitle("Clients")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddClient = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.trustBlue)
                    }
                }
            }
            .sheet(isPresented: $showAddClient) {
                ClientFormView(client: nil)
            }
        }
    }

    private var filteredClients: [Client] {
        if searchText.isEmpty { return clients }
        return clients.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.company.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func deleteClients(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredClients[index])
        }
        try? modelContext.save()
    }
}
