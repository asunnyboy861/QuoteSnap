import SwiftUI
import SwiftData

struct QuoteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Quote.createdAt, order: .reverse) private var quotes: [Quote]
    @State private var selectedFilter: QuoteStatus?
    @State private var searchText = ""
    @AppStorage("isPro") private var isPro = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    let remaining = QuoteService.freeMonthlyLimit - QuoteService(modelContext: modelContext).getMonthlyQuoteCount()
                    FreeQuoteCounter(remaining: max(0, remaining), isPro: isPro)

                    filterPills

                    if filteredQuotes.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredQuotes) { quote in
                                NavigationLink(destination: QuoteDetailView(quote: quote)) {
                                    QuoteRowView(quote: quote)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .ipadMaxWidth()
            }
            .background(Color.bgLight)
            .navigationTitle("Quotes")
            .searchable(text: $searchText, prompt: "Search quotes...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: NewQuoteView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.trustBlue)
                    }
                }
            }
        }
    }

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(title: "All", isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }
                ForEach(QuoteStatus.allCases, id: \.self) { status in
                    FilterPill(title: status.rawValue, isSelected: selectedFilter == status) {
                        selectedFilter = status
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var filteredQuotes: [Quote] {
        var result = quotes
        if let filter = selectedFilter {
            result = result.filter { $0.quoteStatus == filter }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.number.localizedCaseInsensitiveContains(searchText) ||
                $0.client?.name.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        return result
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.textSecondary.opacity(0.5))
            Text("No quotes yet")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
            Text("Tap + to create your first quote")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, 80)
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.trustBlue : Color.cardWhite)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .cornerRadius(20)
                .shadow(color: .black.opacity(isSelected ? 0 : 0.04), radius: 4, y: 2)
        }
    }
}

struct QuoteRowView: View {
    let quote: Quote

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(quote.number)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    StatusBadge(status: quote.quoteStatus)
                }
                Text(quote.client?.name ?? "No Client")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                Text(quote.date.formattedShort)
                    .font(.caption)
                    .foregroundColor(.textSecondary.opacity(0.7))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(currencyFormat(quote.total))
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                if quote.convertedToInvoice {
                    Text("Invoiced")
                        .font(.caption2)
                        .foregroundColor(.tealGreen)
                }
            }
        }
        .padding()
        .background(Color.cardWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    private func currencyFormat(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
