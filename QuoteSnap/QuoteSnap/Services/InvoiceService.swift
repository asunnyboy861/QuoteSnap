import Foundation
import SwiftData

@Observable
final class InvoiceService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func convertQuoteToInvoice(_ quote: Quote) -> Invoice {
        let invoice = Invoice(from: quote)
        modelContext.insert(invoice)
        quote.convertedToInvoice = true
        quote.linkedInvoiceId = invoice.id
        try? modelContext.save()
        return invoice
    }

    func updateInvoice(_ invoice: Invoice) {
        invoice.updatedAt = Date()
        try? modelContext.save()
    }

    func deleteInvoice(_ invoice: Invoice) {
        modelContext.delete(invoice)
        try? modelContext.save()
    }

    func fetchInvoices(sortBy: SortDescriptor<Invoice> = SortDescriptor(\.createdAt, order: .reverse)) throws -> [Invoice] {
        let descriptor = FetchDescriptor<Invoice>(sortBy: [sortBy])
        return try modelContext.fetch(descriptor)
    }

    func fetchInvoices(status: InvoiceStatus) throws -> [Invoice] {
        let descriptor = FetchDescriptor<Invoice>(predicate: #Predicate { $0.status == status.rawValue }, sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }
}
