import Foundation
import SwiftData

@Model
final class Quote {
    var id: UUID
    var number: String
    var date: Date
    var validUntil: Date?
    var status: String
    var itemsData: Data
    var subtotal: Double
    var taxRate: Double
    var taxAmount: Double
    var discountType: String
    var discountValue: Double
    var total: Double
    var notes: String
    var terms: String
    var templateType: String
    var convertedToInvoice: Bool
    var linkedInvoiceId: UUID?
    var createdAt: Date
    var updatedAt: Date
    var client: Client?

    var items: [LineItem] {
        get {
            guard let data = itemsData as Data? else { return [] }
            return (try? JSONDecoder().decode([LineItem].self, from: data)) ?? []
        }
        set {
            itemsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    var quoteStatus: QuoteStatus {
        get { QuoteStatus(rawValue: status) ?? .draft }
        set { status = newValue.rawValue }
    }

    var quoteDiscountType: DiscountType {
        get { DiscountType(rawValue: discountType) ?? .percentage }
        set { discountType = newValue.rawValue }
    }

    var quoteTemplateType: TemplateType {
        get { TemplateType(rawValue: templateType) ?? .general }
        set { templateType = newValue.rawValue }
    }

    init(id: UUID = UUID(), number: String = "", date: Date = Date(), validUntil: Date? = nil, status: QuoteStatus = .draft, items: [LineItem] = [], subtotal: Double = 0, taxRate: Double = 0, taxAmount: Double = 0, discountType: DiscountType = .percentage, discountValue: Double = 0, total: Double = 0, notes: String = "", terms: String = "", templateType: TemplateType = .general, convertedToInvoice: Bool = false, linkedInvoiceId: UUID? = nil, client: Client? = nil) {
        self.id = id
        self.number = number
        self.date = date
        self.validUntil = validUntil
        self.status = status.rawValue
        self.itemsData = (try? JSONEncoder().encode(items)) ?? Data()
        self.subtotal = subtotal
        self.taxRate = taxRate
        self.taxAmount = taxAmount
        self.discountType = discountType.rawValue
        self.discountValue = discountValue
        self.total = total
        self.notes = notes
        self.terms = terms
        self.templateType = templateType.rawValue
        self.convertedToInvoice = convertedToInvoice
        self.linkedInvoiceId = linkedInvoiceId
        self.createdAt = Date()
        self.updatedAt = Date()
        self.client = client
    }

    func recalculate() {
        var currentItems = items
        for i in currentItems.indices {
            currentItems[i].recalculate()
        }
        items = currentItems
        subtotal = currentItems.map(\.total).reduce(0, +)
        let discountAmount: Double
        if quoteDiscountType == .percentage {
            discountAmount = subtotal * discountValue / 100
        } else {
            discountAmount = discountValue
        }
        let afterDiscount = subtotal - discountAmount
        taxAmount = afterDiscount * taxRate / 100
        total = afterDiscount + taxAmount
        updatedAt = Date()
    }
}
