import SwiftUI
import SwiftData
import PDFKit

struct QuoteDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isPro") private var isPro = false
    let quote: Quote

    @State private var showShareSheet = false
    @State private var showStatusPicker = false
    @State private var pdfData: Data?
    @State private var showSignatureView = false
    @State private var signatureData: Data?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                statusActions
                itemsCard
                totalsCard
                notesCard
                if isPro {
                    signatureSection
                }
                actionButtons
            }
            .padding()
            .ipadMaxWidth()
        }
        .background(Color.bgLight)
        .navigationTitle(quote.number)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { generatePDF() }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                StatusBadge(status: quote.quoteStatus)
                Spacer()
                Text(quote.date.formattedShort)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            if let client = quote.client {
                Text(client.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                if !client.company.isEmpty {
                    Text(client.company)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
            }
            if let validUntil = quote.validUntil {
                Text("Valid until \(validUntil.formattedShort)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    private var statusActions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach([QuoteStatus.sent, .accepted, .declined], id: \.self) { status in
                    Button(action: { updateStatus(status) }) {
                        Text("Mark \(status.rawValue)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(statusColor(for: status).opacity(0.12))
                            .foregroundColor(statusColor(for: status))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private var itemsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Items")
                .font(.headline)
                .foregroundColor(.textPrimary)

            ForEach(quote.items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                        Text("\(String(format: "%.0f", item.quantity)) \(item.unit) x \(currencyFormat(item.unitPrice))")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    Spacer()
                    Text(currencyFormat(item.total))
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    private var totalsCard: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Subtotal")
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(currencyFormat(quote.subtotal))
                    .foregroundColor(.textPrimary)
            }
            if quote.discountValue > 0 {
                HStack {
                    Text(quote.quoteDiscountType == .percentage ? "Discount (\(Int(quote.discountValue))%)" : "Discount")
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text("-\(currencyFormat(discountAmount))")
                        .foregroundColor(.dangerRed)
                }
            }
            if quote.taxRate > 0 {
                HStack {
                    Text("Tax (\(Int(quote.taxRate))%)")
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text(currencyFormat(quote.taxAmount))
                        .foregroundColor(.textPrimary)
                }
            }
            Divider()
            HStack {
                Text("Total")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text(currencyFormat(quote.total))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.trustBlue)
            }
        }
        .padding()
        .background(Color.cardWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    private var notesCard: some View {
        Group {
            if !quote.notes.isEmpty || !quote.terms.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if !quote.notes.isEmpty {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        Text(quote.notes)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    if !quote.terms.isEmpty {
                        Text("Terms")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        Text(quote.terms)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.cardWhite)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
            }
        }
    }

    private var signatureSection: some View {
        VStack(spacing: 12) {
            SignatureView(signatureData: $signatureData)
        }
        .padding()
        .background(Color.cardWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showShareSheet = true }) {
                Label("Share PDF", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.trustBlue)
                    .cornerRadius(12)
            }

            if !quote.convertedToInvoice {
                NavigationLink(destination: InvoiceDetailView(invoice: convertToInvoice())) {
                    Label("Convert to Invoice", systemImage: "doc.on.doc")
                        .font(.headline)
                        .foregroundColor(.trustBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.trustBlue.opacity(0.1))
                        .cornerRadius(12)
                }
            } else {
                Label("Already Invoiced", systemImage: "checkmark.circle")
                    .font(.headline)
                    .foregroundColor(.tealGreen)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tealGreen.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let data = pdfData {
                ShareSheet(activityItems: [data])
            }
        }
    }

    private func updateStatus(_ status: QuoteStatus) {
        quote.quoteStatus = status
        try? modelContext.save()
        generatePDF()
    }

    private func generatePDF() {
        let descriptor = FetchDescriptor<BusinessInfo>()
        let businessInfo = (try? modelContext.fetch(descriptor))?.first ?? BusinessInfo()
        pdfData = PDFGenerator.generateQuotePDF(quote: quote, businessInfo: businessInfo)
    }

    private func convertToInvoice() -> Invoice {
        let service = InvoiceService(modelContext: modelContext)
        return service.convertQuoteToInvoice(quote)
    }

    private var discountAmount: Double {
        quote.quoteDiscountType == .percentage ? quote.subtotal * quote.discountValue / 100 : quote.discountValue
    }

    private func currencyFormat(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    private func statusColor(for status: QuoteStatus) -> Color {
        switch status {
        case .sent: return .trustBlue
        case .accepted: return .successGreen
        case .declined: return .dangerRed
        default: return .textSecondary
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
