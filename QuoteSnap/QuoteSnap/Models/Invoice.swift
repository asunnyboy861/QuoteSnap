import Foundation
import SwiftData

@Model
final class Invoice {
    var id: UUID
    var number: String
    var date: Date
    var dueDate: Date?
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
    var linkedQuoteId: UUID?
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

    var invoiceStatus: InvoiceStatus {
        get { InvoiceStatus(rawValue: status) ?? .pending }
        set { status = newValue.rawValue }
    }

    var invoiceDiscountType: DiscountType {
        get { DiscountType(rawValue: discountType) ?? .percentage }
        set { discountType = newValue.rawValue }
    }

    var invoiceTemplateType: TemplateType {
        get { TemplateType(rawValue: templateType) ?? .general }
        set { templateType = newValue.rawValue }
    }

    init(id: UUID = UUID(), number: String = "", date: Date = Date(), dueDate: Date? = nil, status: InvoiceStatus = .pending, items: [LineItem] = [], subtotal: Double = 0, taxRate: Double = 0, taxAmount: Double = 0, discountType: DiscountType = .percentage, discountValue: Double = 0, total: Double = 0, notes: String = "", terms: String = "", templateType: TemplateType = .general, linkedQuoteId: UUID? = nil, client: Client? = nil) {
        self.id = id
        self.number = number
        self.date = date
        self.dueDate = dueDate
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
        self.linkedQuoteId = linkedQuoteId
        self.createdAt = Date()
        self.updatedAt = Date()
        self.client = client
    }

    convenience init(from quote: Quote) {
        self.init(
            number: InvoiceNumberGenerator.next(),
            date: Date(),
            dueDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
            status: .pending,
            items: quote.items,
            subtotal: quote.subtotal,
            taxRate: quote.taxRate,
            taxAmount: quote.taxAmount,
            discountType: quote.quoteDiscountType,
            discountValue: quote.discountValue,
            total: quote.total,
            notes: quote.notes,
            terms: quote.terms,
            templateType: quote.quoteTemplateType,
            linkedQuoteId: quote.id,
            client: quote.client
        )
    }
}

struct InvoiceNumberGenerator {
    private static let lastNumberKey = "lastInvoiceNumber"

    static func next() -> String {
        let lastNum = UserDefaults.standard.integer(forKey: lastNumberKey)
        let nextNum = lastNum + 1
        UserDefaults.standard.set(nextNum, forKey: lastNumberKey)
        return String(format: "INV-%04d", nextNum)
    }
}
