import Foundation

struct LineItem: Codable, Identifiable {
    var id: UUID
    var description: String
    var quantity: Double
    var unit: String
    var unitPrice: Double
    var total: Double

    init(id: UUID = UUID(), description: String = "", quantity: Double = 1, unit: String = "each", unitPrice: Double = 0, total: Double = 0) {
        self.id = id
        self.description = description
        self.quantity = quantity
        self.unit = unit
        self.unitPrice = unitPrice
        self.total = quantity * unitPrice
    }

    mutating func recalculate() {
        total = quantity * unitPrice
    }
}
