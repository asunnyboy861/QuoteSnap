import Foundation
import SwiftData
import Contacts

@Observable
final class ClientViewModel {
    private let clientService: ClientService

    init(modelContext: ModelContext) {
        self.clientService = ClientService(modelContext: modelContext)
    }

    func importFromContacts(_ contact: CNContact) -> Client {
        clientService.importFromContacts(contact)
    }
}
