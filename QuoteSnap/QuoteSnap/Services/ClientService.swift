import Foundation
import SwiftData
import Contacts

@Observable
final class ClientService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func createClient(name: String, email: String, phone: String, company: String, street: String, city: String, state: String, zip: String, notes: String) -> Client {
        let client = Client(name: name, email: email, phone: phone, company: company, street: street, city: city, state: state, zip: zip, notes: notes)
        modelContext.insert(client)
        try? modelContext.save()
        return client
    }

    func updateClient(_ client: Client) {
        try? modelContext.save()
    }

    func deleteClient(_ client: Client) {
        modelContext.delete(client)
        try? modelContext.save()
    }

    func fetchClients(sortBy: SortDescriptor<Client> = SortDescriptor(\.name)) throws -> [Client] {
        let descriptor = FetchDescriptor<Client>(sortBy: [sortBy])
        return try modelContext.fetch(descriptor)
    }

    func searchClients(query: String) throws -> [Client] {
        let descriptor = FetchDescriptor<Client>(predicate: #Predicate { $0.name.localizedStandardContains(query) }, sortBy: [SortDescriptor(\.name)])
        return try modelContext.fetch(descriptor)
    }

    func importFromContacts(_ contact: CNContact) -> Client {
        let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
        let email = contact.emailAddresses.first?.value as String? ?? ""
        let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
        let company = contact.organizationName
        let postal = contact.postalAddresses.first?.value
        let street = postal?.street ?? ""
        let city = postal?.city ?? ""
        let state = postal?.state ?? ""
        let zip = postal?.postalCode ?? ""

        return createClient(name: name, email: email, phone: phone, company: company, street: street, city: city, state: state, zip: zip, notes: "")
    }
}
