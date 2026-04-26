import Foundation

@Observable
final class SettingsViewModel {
    var isPro = false
    var purchaseManager = PurchaseManager()

    init() {
        isPro = purchaseManager.isPro
    }

    func purchasePro() async {
        await purchaseManager.purchasePro()
        isPro = purchaseManager.isPro
    }

    func restorePurchases() async {
        await purchaseManager.restorePurchases()
        isPro = purchaseManager.isPro
    }
}
