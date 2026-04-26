import UIKit
import MessageUI

@Observable
final class ShareService: NSObject {
    var isPresentingMailComposer = false
    var mailComposerResult: Result<Void, Error>?
    private var pdfData: Data?
    private var fileName: String = "document.pdf"
    private var recipientEmail: String = ""
    private var subject: String = ""

    func sharePDF(_ data: Data, fileName: String, from viewController: UIViewController?) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? data.write(to: tempURL)
        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController?.view
            popover.sourceRect = CGRect(x: viewController?.view.bounds.midX ?? 0, y: viewController?.view.bounds.midY ?? 0, width: 0, height: 0)
        }
        viewController?.present(activityVC, animated: true)
    }

    func emailPDF(_ data: Data, fileName: String, to recipient: String, subject: String, from viewController: UIViewController?) {
        guard MFMailComposeViewController.canSendMail() else {
            sharePDF(data, fileName: fileName, from: viewController)
            return
        }
        self.pdfData = data
        self.fileName = fileName
        self.recipientEmail = recipient
        self.subject = subject

        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([recipient])
        composer.setSubject(subject)
        composer.addAttachmentData(data, mimeType: "application/pdf", fileName: fileName)
        viewController?.present(composer, animated: true)
    }
}

extension ShareService: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if let error = error {
            mailComposerResult = .failure(error)
        } else {
            mailComposerResult = .success(())
        }
    }
}
