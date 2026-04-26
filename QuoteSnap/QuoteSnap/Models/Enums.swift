import Foundation

enum QuoteStatus: String, Codable, CaseIterable {
    case draft = "Draft"
    case sent = "Sent"
    case accepted = "Accepted"
    case declined = "Declined"
    case expired = "Expired"
}

enum InvoiceStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case paid = "Paid"
    case overdue = "Overdue"
    case cancelled = "Cancelled"
}

enum DiscountType: String, Codable, CaseIterable {
    case percentage = "Percentage"
    case fixed = "Fixed Amount"
}

enum TemplateType: String, Codable, CaseIterable {
    case landscaping = "Landscaping"
    case cleaning = "Cleaning"
    case plumbing = "Plumbing"
    case electrical = "Electrical"
    case handyman = "Handyman"
    case hvac = "HVAC"
    case painting = "Painting"
    case general = "General"
}

enum UnitType: String, Codable, CaseIterable {
    case hour = "hr"
    case squareFoot = "sq ft"
    case each = "each"
    case lot = "lot"
    case room = "room"
    case wall = "wall"
}
