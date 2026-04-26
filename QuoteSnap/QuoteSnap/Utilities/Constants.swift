import Foundation

struct Constants {
    static let freeMonthlyQuoteLimit = 3
    static let proPrice = "$9.99"
    static let proProductID = "com.zzoutuo.QuoteSnap.pro"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    static let supportEmail = "support@zzoutuo.com"
    static let privacyPolicyURL = "https://zzoutuo.github.io/QuoteSnap/privacy"
    static let termsOfServiceURL = "https://zzoutuo.github.io/QuoteSnap/terms"
    static let defaultTaxRate = 0.0
    static let defaultValidDays = 30
}
