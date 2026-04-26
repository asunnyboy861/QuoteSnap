import SwiftUI
import SwiftData

struct NewQuoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isPro") private var isPro = false

    @State private var selectedClient: Client?
    @State private var selectedTemplate: TemplateType = .general
    @State private var lineItems: [LineItem] = []
    @State private var taxRate: Double = 0
    @State private var discountType: DiscountType = .percentage
    @State private var discountValue: Double = 0
    @State private var notes: String = ""
    @State private var terms: String = ""
    @State private var validUntil = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var showClientPicker = false
    @State private var showTemplatePicker = false
    @State private var showLimitAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    clientSection
                    templateSection
                    lineItemsSection
                    pricingSection
                    notesSection
                }
                .padding()
                .ipadMaxWidth()
            }
            .background(Color.bgLight)
            .navigationTitle("New Quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveQuote() }
                        .fontWeight(.bold)
                        .foregroundColor(.trustBlue)
                }
            }
            .alert("Free Limit Reached", isPresented: $showLimitAlert) {
                Button("Upgrade to Pro") { }
                Button("OK", role: .cancel) { }
            } message: {
                Text("You've used all 3 free quotes this month. Upgrade to Pro for unlimited quotes.")
            }
        }
    }

    private var clientSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Client")
                .font(.headline)
                .foregroundColor(.textPrimary)

            Button(action: { showClientPicker = true }) {
                HStack {
                    if let client = selectedClient {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(client.name)
                                .font(.body)
                                .foregroundColor(.textPrimary)
                            Text(client.email)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    } else {
                        Text("Select Client")
                            .foregroundColor(.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textSecondary)
                        .font(.caption)
                }
                .padding()
                .background(Color.cardWhite)
                .cornerRadius(10)
            }
            .sheet(isPresented: $showClientPicker) {
                ClientPickerSheet(selectedClient: $selectedClient)
            }
        }
    }

    private var templateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Template")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                Spacer()
                Button(showTemplatePicker ? "Hide" : "Change") {
                    withAnimation { showTemplatePicker.toggle() }
                }
                .font(.subheadline)
                .foregroundColor(.trustBlue)
            }

            if showTemplatePicker {
                TemplatePicker(selectedTemplate: $selectedTemplate)
                    .onChange(of: selectedTemplate) { _, newTemplate in
                        let presetItems = TemplateService.getPresetItems(for: newTemplate)
                        if !presetItems.isEmpty && lineItems.isEmpty {
                            lineItems = presetItems
                        }
                    }
            }
        }
    }

    private var lineItemsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Line Items")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                Spacer()
                Button(action: addLineItem) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.trustBlue)
                }
            }

            ForEach($lineItems) { $item in
                LineItemEditView(item: $item, onDelete: {
                    lineItems.removeAll { $0.id == item.id }
                })
            }

            if lineItems.isEmpty {
                Text("No items yet. Tap + to add.")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cardWhite)
                    .cornerRadius(10)
            }
        }
    }

    private var pricingSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Subtotal")
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(currencyFormat(lineItems.map(\.total).reduce(0, +)))
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
            }

            HStack {
                Text("Discount")
                    .foregroundColor(.textSecondary)
                Picker("", selection: $discountType) {
                    ForEach(DiscountType.allCases, id: \.self) { dt in
                        Text(dt == .percentage ? "%" : "$").tag(dt)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 80)
                TextField("0", value: $discountValue, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
            }

            HStack {
                Text("Tax %")
                    .foregroundColor(.textSecondary)
                Spacer()
                TextField("0", value: $taxRate, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
            }

            Divider()

            HStack {
                Text("Total")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text(currencyFormat(calculateTotal()))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.trustBlue)
            }
        }
        .padding()
        .background(Color.cardWhite)
        .cornerRadius(12)
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.headline)
                .foregroundColor(.textPrimary)
            TextEditor(text: $notes)
                .frame(height: 60)
                .padding(8)
                .background(Color.cardWhite)
                .cornerRadius(10)

            Text("Terms & Conditions")
                .font(.headline)
                .foregroundColor(.textPrimary)
            TextEditor(text: $terms)
                .frame(height: 60)
                .padding(8)
                .background(Color.cardWhite)
                .cornerRadius(10)

            DatePicker("Valid Until", selection: $validUntil, displayedComponents: .date)
                .font(.subheadline)
        }
    }

    private func addLineItem() {
        lineItems.append(LineItem())
    }

    private func calculateTotal() -> Double {
        let subtotal = lineItems.map(\.total).reduce(0, +)
        let discountAmount = discountType == .percentage ? subtotal * discountValue / 100 : discountValue
        let afterDiscount = subtotal - discountAmount
        let taxAmount = afterDiscount * taxRate / 100
        return afterDiscount + taxAmount
    }

    private func saveQuote() {
        let service = QuoteService(modelContext: modelContext)
        guard service.canCreateQuote(isPro: isPro) else {
            showLimitAlert = true
            return
        }
        let _ = service.createQuote(
            client: selectedClient,
            templateType: selectedTemplate,
            items: lineItems,
            taxRate: taxRate,
            discountType: discountType,
            discountValue: discountValue,
            notes: notes,
            terms: terms,
            validUntil: validUntil
        )
        dismiss()
    }

    private func currencyFormat(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct ClientPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Client.name) private var clients: [Client]
    @Binding var selectedClient: Client?
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredClients) { client in
                    Button(action: {
                        selectedClient = client
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(client.name)
                                    .foregroundColor(.textPrimary)
                                Text(client.email)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            if selectedClient?.id == client.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.trustBlue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search clients...")
            .navigationTitle("Select Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var filteredClients: [Client] {
        if searchText.isEmpty { return clients }
        return clients.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
