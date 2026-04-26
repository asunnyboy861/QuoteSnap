import SwiftUI

struct LineItemEditView: View {
    @Binding var item: LineItem
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                TextField("Description", text: $item.description)
                    .font(.subheadline)
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.dangerRed)
                        .font(.caption)
                }
            }

            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Qty")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    TextField("1", value: $item.quantity, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                }
                .frame(width: 60)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Unit")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    Picker("", selection: $item.unit) {
                        ForEach(UnitType.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit.rawValue)
                        }
                    }
                    .labelsHidden()
                    .frame(height: 32)
                }
                .frame(width: 70)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Price")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    TextField("0", value: $item.unitPrice, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Total")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    Text(currencyFormat(item.quantity * item.unitPrice))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .padding()
        .background(Color.cardWhite)
        .cornerRadius(10)
        .onChange(of: item.quantity) { _, _ in item.recalculate() }
        .onChange(of: item.unitPrice) { _, _ in item.recalculate() }
    }

    private func currencyFormat(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
