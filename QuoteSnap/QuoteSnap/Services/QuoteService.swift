import Foundation
import SwiftData

struct QuoteNumberGenerator {
    private static let lastNumberKey = "lastQuoteNumber"

    static func next() -> String {
        let lastNum = UserDefaults.standard.integer(forKey: lastNumberKey)
        let nextNum = lastNum + 1
        UserDefaults.standard.set(nextNum, forKey: lastNumberKey)
        return String(format: "Q-%04d", nextNum)
    }
}

@Observable
final class QuoteService {
    private let modelContext: ModelContext

    static let freeMonthlyLimit = 3
    private static let freeQuoteCountPrefix = "freeQuoteCount_"

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func canCreateQuote(isPro: Bool) -> Bool {
        if isPro { return true }
        return getMonthlyQuoteCount() < Self.freeMonthlyLimit
    }

    func getMonthlyQuoteCount() -> Int {
        let key = currentMonthKey()
        return UserDefaults.standard.integer(forKey: key)
    }

    func incrementQuoteCount() {
        let key = currentMonthKey()
        let current = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(current + 1, forKey: key)
    }

    func remainingFreeQuotes(isPro: Bool) -> Int? {
        if isPro { return nil }
        return max(0, Self.freeMonthlyLimit - getMonthlyQuoteCount())
    }

    func createQuote(client: Client?, templateType: TemplateType, items: [LineItem], taxRate: Double, discountType: DiscountType, discountValue: Double, notes: String, terms: String, validUntil: Date?) -> Quote {
        let quote = Quote(
            number: QuoteNumberGenerator.next(),
            date: Date(),
            validUntil: validUntil,
            status: .draft,
            items: items,
            taxRate: taxRate,
            discountType: discountType,
            discountValue: discountValue,
            notes: notes,
            terms: terms,
            templateType: templateType,
            client: client
        )
        quote.recalculate()
        modelContext.insert(quote)
        incrementQuoteCount()
        return quote
    }

    func updateQuote(_ quote: Quote) {
        quote.recalculate()
        try? modelContext.save()
    }

    func deleteQuote(_ quote: Quote) {
        modelContext.delete(quote)
        try? modelContext.save()
    }

    func fetchQuotes(sortBy: SortDescriptor<Quote> = SortDescriptor(\.createdAt, order: .reverse)) throws -> [Quote] {
        let descriptor = FetchDescriptor<Quote>(sortBy: [sortBy])
        return try modelContext.fetch(descriptor)
    }

    func fetchQuotes(status: QuoteStatus) throws -> [Quote] {
        let descriptor = FetchDescriptor<Quote>(predicate: #Predicate { $0.status == status.rawValue }, sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }

    private func currentMonthKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return Self.freeQuoteCountPrefix + formatter.string(from: Date())
    }
}
