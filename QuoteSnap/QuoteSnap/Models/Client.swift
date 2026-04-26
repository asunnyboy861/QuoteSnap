import Foundation
import SwiftData

@Model
final class Client {
    var id: UUID
    var name: String
    var email: String
    var phone: String
    var company: String
    var street: String
    var city: String
    var state: String
    var zip: String
    var notes: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade, inverse: \Quote.client)
    var quotes: [Quote] = []

    init(id: UUID = UUID(), name: String = "", email: String = "", phone: String = "", company: String = "", street: String = "", city: String = "", state: String = "", zip: String = "", notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.company = company
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.notes = notes
        self.createdAt = createdAt
    }
}
