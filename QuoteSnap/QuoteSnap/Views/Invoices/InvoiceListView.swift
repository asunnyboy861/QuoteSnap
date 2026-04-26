import SwiftUI
import SwiftData

struct InvoiceListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Invoice.createdAt, order: .reverse) private var invoices: [Invoice]
    @State private var selectedFilter: InvoiceStatus?
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    filterPills

                    if filteredInvoices.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredInvoices) { invoice in
                                NavigationLink(destination: InvoiceDetailView(invoice: invoice)) {
                                    InvoiceRowView(invoice: invoice)
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
            .navigationTitle("Invoices")
            .searchable(text: $searchText, prompt: "Search invoices...")
        }
    }

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(title: "All", isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }
                ForEach(InvoiceStatus.allCases, id: \.self) { status in
                    FilterPill(title: status.rawValue, isSelected: selectedFilter == status) {
                        selectedFilter = status
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var filteredInvoices: [Invoice] {
        var result = invoices
        if let filter = selectedFilter {
            result = result.filter { $0.invoiceStatus == filter }
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
            Text("No invoices yet")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
            Text("Convert a quote to create an invoice")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, 80)
    }
}

struct InvoiceRowView: View {
    let invoice: Invoice

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(invoice.number)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    InvoiceStatusBadge(status: invoice.invoiceStatus)
                }
                Text(invoice.client?.name ?? "No Client")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                Text(invoice.date.formattedShort)
                    .font(.caption)
                    .foregroundColor(.textSecondary.opacity(0.7))
            }

            Spacer()

            Text(currencyFormat(invoice.total))
                .font(.headline)
                .foregroundColor(.textPrimary)
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
