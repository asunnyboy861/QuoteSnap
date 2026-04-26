import Foundation
import SwiftData

@Observable
final class QuoteViewModel {
    private let quoteService: QuoteService

    init(modelContext: ModelContext) {
        self.quoteService = QuoteService(modelContext: modelContext)
    }

    func canCreateQuote(isPro: Bool) -> Bool {
        quoteService.canCreateQuote(isPro: isPro)
    }

    func remainingFreeQuotes(isPro: Bool) -> Int? {
        quoteService.remainingFreeQuotes(isPro: isPro)
    }

    func monthlyQuoteCount() -> Int {
        quoteService.getMonthlyQuoteCount()
    }
}
