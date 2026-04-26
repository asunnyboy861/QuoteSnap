import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isPro") private var isPro = false
    @State private var purchaseManager = PurchaseManager()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.warmOrange)
                        .padding(.top, 20)

                    Text("Upgrade to Pro")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)

                    Text("One-time purchase. No subscription.")
                        .font(.title3)
                        .foregroundColor(.successGreen)
                        .fontWeight(.medium)

                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "infinity.circle.fill", title: "Unlimited Quotes", subtitle: "No monthly limits", isIncluded: true)
                        FeatureRow(icon: "paintbrush.fill", title: "Custom Branding", subtitle: "Logo, colors, company info", isIncluded: true)
                        FeatureRow(icon: "signature", title: "E-Signatures", subtitle: "Customer sign on screen", isIncluded: true)
                        FeatureRow(icon: "icloud.fill", title: "iCloud Sync", subtitle: "Access on all devices", isIncluded: true)
                        FeatureRow(icon: "doc.on.doc.fill", title: "Quote → Invoice", subtitle: "One-tap conversion", isIncluded: true)
                    }
                    .padding()
                    .background(Color.cardWhite)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 2)

                    comparisonTable

                    Button(action: purchase) {
                        if purchaseManager.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.trustBlue)
                                .cornerRadius(14)
                        } else {
                            Text("Buy Pro — \(purchaseManager.displayPrice)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.trustBlue)
                                .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal)

                    if let error = purchaseManager.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.dangerRed)
                            .padding(.horizontal)
                    }

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .background(Color.bgLight)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Feature")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Free")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(width: 60)
                Text("Pro")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(width: 60)
                    .foregroundColor(.trustBlue)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.bgLight)

            ComparisonRow(title: "Quotes/month", free: "3", pro: "Unlimited")
            ComparisonRow(title: "Branding", free: "—", pro: "✓")
            ComparisonRow(title: "E-Signature", free: "—", pro: "✓")
            ComparisonRow(title: "iCloud Sync", free: "—", pro: "✓")
            ComparisonRow(title: "Templates", free: "✓", pro: "✓")
            ComparisonRow(title: "PDF Export", free: "✓", pro: "✓")
        }
        .background(Color.cardWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    private func purchase() {
        Task {
            await purchaseManager.purchasePro()
            if purchaseManager.isPro {
                isPro = true
                dismiss()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isIncluded: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.trustBlue)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            Spacer()
        }
    }
}

struct ComparisonRow: View {
    let title: String
    let free: String
    let pro: String

    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(free)
                .font(.caption)
                .frame(width: 60)
                .foregroundColor(free == "—" ? .textSecondary : .textPrimary)
            Text(pro)
                .font(.caption)
                .frame(width: 60)
                .foregroundColor(pro == "✓" ? .successGreen : .textPrimary)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        Divider()
    }
}
