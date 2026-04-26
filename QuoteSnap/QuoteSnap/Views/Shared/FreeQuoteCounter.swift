import SwiftUI

struct FreeQuoteCounter: View {
    let remaining: Int
    let isPro: Bool

    var body: some View {
        if !isPro {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.warmOrange)
                Text("\(remaining) free quote\(remaining == 1 ? "" : "s") remaining this month")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                Spacer()
                NavigationLink(destination: PaywallView()) {
                    Text("Go Pro")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.trustBlue)
                        .cornerRadius(8)
                }
            }
            .padding(12)
            .background(Color.warmOrange.opacity(0.08))
            .cornerRadius(10)
        }
    }
}
