import Foundation
import SwiftData

@Observable
final class InvoiceViewModel {
    private let invoiceService: InvoiceService

    init(modelContext: ModelContext) {
        self.invoiceService = InvoiceService(modelContext: modelContext)
    }

    func convertQuoteToInvoice(_ quote: Quote) -> Invoice {
        invoiceService.convertQuoteToInvoice(quote)
    }
}
