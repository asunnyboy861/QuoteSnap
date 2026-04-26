import SwiftUI
import SwiftData

struct InvoiceDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let invoice: Invoice
    @State private var showShareSheet = false
    @State private var pdfData: Data?

    init(invoice: Invoice) {
        self.invoice = invoice
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                statusActions
                itemsCard
                totalsCard
                notesCard
                actionButtons
            }
            .padding()
            .ipadMaxWidth()
        }
        .background(Color.bgLight)
        .navigationTitle(invoice.number)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { generatePDF() }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                InvoiceStatusBadge(status: invoice.invoiceStatus)
                Spacer()
                Text(invoice.date.formattedShort)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            if let client = invoice.client {
                Text(client.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            if let dueDate = invoice.dueDate {
                Text("Due \(dueDate.formattedShort)")
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
                Button(action: { updateStatus(.paid) }) {
                    Text("Mark Paid")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.successGreen.opacity(0.12))
                        .foregroundColor(.successGreen)
                        .cornerRadius(8)
                }
                Button(action: { updateStatus(.overdue) }) {
                    Text("Mark Overdue")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.dangerRed.opacity(0.12))
                        .foregroundColor(.dangerRed)
                        .cornerRadius(8)
                }
            }
        }
    }

    private var itemsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Items")
                .font(.headline)
                .foregroundColor(.textPrimary)
            ForEach(invoice.items) { item in
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
                Text("Subtotal").foregroundColor(.textSecondary)
                Spacer()
                Text(currencyFormat(invoice.subtotal)).foregroundColor(.textPrimary)
            }
            if invoice.discountValue > 0 {
                HStack {
                    Text("Discount").foregroundColor(.textSecondary)
                    Spacer()
                    Text("-\(currencyFormat(invoiceDiscountAmount))").foregroundColor(.dangerRed)
                }
            }
            if invoice.taxRate > 0 {
                HStack {
                    Text("Tax (\(Int(invoice.taxRate))%)").foregroundColor(.textSecondary)
                    Spacer()
                    Text(currencyFormat(invoice.taxAmount)).foregroundColor(.textPrimary)
                }
            }
            Divider()
            HStack {
                Text("Total").font(.title3).fontWeight(.bold).foregroundColor(.textPrimary)
                Spacer()
                Text(currencyFormat(invoice.total)).font(.title3).fontWeight(.bold).foregroundColor(.trustBlue)
            }
        }
        .padding()
        .background(Color.cardWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    private var notesCard: some View {
        Group {
            if !invoice.notes.isEmpty || !invoice.terms.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if !invoice.notes.isEmpty {
                        Text("Notes").font(.headline).foregroundColor(.textPrimary)
                        Text(invoice.notes).font(.subheadline).foregroundColor(.textSecondary)
                    }
                    if !invoice.terms.isEmpty {
                        Text("Terms").font(.headline).foregroundColor(.textPrimary)
                        Text(invoice.terms).font(.subheadline).foregroundColor(.textSecondary)
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

    private var actionButtons: some View {
        Button(action: { showShareSheet = true }) {
            Label("Share Invoice PDF", systemImage: "square.and.arrow.up")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.trustBlue)
                .cornerRadius(12)
        }
        .sheet(isPresented: $showShareSheet) {
            if let data = pdfData {
                ShareSheet(activityItems: [data])
            }
        }
    }

    private func updateStatus(_ status: InvoiceStatus) {
        invoice.invoiceStatus = status
        try? modelContext.save()
    }

    private func generatePDF() {
        let descriptor = FetchDescriptor<BusinessInfo>()
        let businessInfo = (try? modelContext.fetch(descriptor))?.first ?? BusinessInfo()
        pdfData = PDFGenerator.generateInvoicePDF(invoice: invoice, businessInfo: businessInfo)
    }

    private var invoiceDiscountAmount: Double {
        invoice.invoiceDiscountType == .percentage ? invoice.subtotal * invoice.discountValue / 100 : invoice.discountValue
    }

    private func currencyFormat(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
