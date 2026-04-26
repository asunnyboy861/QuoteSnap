import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("isPro") private var isPro = false
    @State private var purchaseManager = PurchaseManager()
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Business Info")) {
                    NavigationLink(destination: BrandingView()) {
                        Label("Company & Branding", systemImage: "paintbrush.fill")
                    }
                }

                Section(header: Text("Subscription")) {
                    HStack {
                        Label("Pro Plan", systemImage: "crown.fill")
                            .foregroundColor(.warmOrange)
                        Spacer()
                        if isPro {
                            Text("Active")
                                .font(.subheadline)
                                .foregroundColor(.successGreen)
                        } else {
                            Text("Free")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    if !isPro {
                        Button(action: { showPaywall = true }) {
                            Text("Upgrade to Pro")
                                .fontWeight(.semibold)
                                .foregroundColor(.trustBlue)
                        }
                    }
                    Button(action: { Task { await purchaseManager.restorePurchases() } }) {
                        Text("Restore Purchases")
                            .foregroundColor(.textSecondary)
                    }
                }

                Section(header: Text("Support")) {
                    NavigationLink(destination: ContactSupportView()) {
                        Label("Contact Support", systemImage: "envelope.fill")
                    }
                }

                Section(header: Text("Legal")) {
                    Link(destination: URL(string: Constants.privacyPolicyURL)!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }
                    Link(destination: URL(string: Constants.termsOfServiceURL)!) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Constants.appVersion)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}
