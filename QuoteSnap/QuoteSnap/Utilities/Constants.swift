import Foundation

struct Constants {
    static let freeMonthlyQuoteLimit = 3
    static let proPrice = "$9.99"
    static let proProductID = "com.zzoutuo.QuoteSnap.pro"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    static let supportEmail = "zzoutuo@163.com"
    static let privacyPolicyURL = "https://asunnyboy861.github.io/QuoteSnap-pages/privacy.html"
    static let termsOfServiceURL = "https://asunnyboy861.github.io/QuoteSnap-pages/terms.html"
    static let defaultTaxRate = 0.0
    static let defaultValidDays = 30
}
