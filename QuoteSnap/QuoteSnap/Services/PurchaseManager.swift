import Foundation
import StoreKit

@Observable
final class PurchaseManager {
    var isPro = false
    var isLoading = false
    var errorMessage: String?
    var displayPrice: String = "$9.99"

    private let productID = "com.zzoutuo.QuoteSnap.premium"
    private var product: Product?

    init() {
        Task {
            await loadProduct()
            await checkPurchaseStatus()
        }
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            if let product = products.first {
                self.product = product
                self.displayPrice = product.displayPrice
            }
        } catch {
            errorMessage = "Failed to load product"
        }
    }

    func purchasePro() async {
        isLoading = true
        errorMessage = nil
        do {
            guard let product = product else {
                let products = try await Product.products(for: [productID])
                guard let firstProduct = products.first else {
                    errorMessage = "Product not found"
                    isLoading = false
                    return
                }
                self.product = firstProduct
                self.displayPrice = firstProduct.displayPrice
                let result = try await firstProduct.purchase()
                handlePurchaseResult(result)
                return
            }
            let result = try await product.purchase()
            handlePurchaseResult(result)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        do {
            try await AppStore.sync()
            await checkPurchaseStatus()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func handlePurchaseResult(_ result: Product.PurchaseResult) {
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                isPro = true
                Task { await transaction.finish() }
            case .unverified:
                errorMessage = "Purchase verification failed"
            }
        case .pending:
            errorMessage = "Purchase is pending approval"
        case .userCancelled:
            break
        @unknown default:
            errorMessage = "Unknown purchase result"
        }
        isLoading = false
    }

    private func checkPurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productID {
                    isPro = transaction.revocationDate == nil
                    Task { await transaction.finish() }
                }
            }
        }
    }
}
