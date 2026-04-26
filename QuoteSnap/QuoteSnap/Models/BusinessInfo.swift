import Foundation
import SwiftData

@Model
final class BusinessInfo {
    var id: UUID
    var name: String
    var email: String
    var phone: String
    var street: String
    var city: String
    var state: String
    var zip: String
    var logoData: Data?
    var brandColorHex: String
    var updatedAt: Date

    init(id: UUID = UUID(), name: String = "", email: String = "", phone: String = "", street: String = "", city: String = "", state: String = "", zip: String = "", logoData: Data? = nil, brandColorHex: String = "#1270C4") {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.logoData = logoData
        self.brandColorHex = brandColorHex
        self.updatedAt = Date()
    }
}
