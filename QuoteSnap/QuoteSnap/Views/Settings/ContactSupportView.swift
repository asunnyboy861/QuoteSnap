import SwiftUI
import MessageUI

struct ContactSupportView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var showMailComposer = false
    @State private var showSuccessAlert = false
    @State private var mailError: String?

    var body: some View {
        Form {
            Section(header: Text("Your Info")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }

            Section(header: Text("Message")) {
                TextEditor(text: $message)
                    .frame(height: 120)
            }

            Section {
                Button(action: sendFeedback) {
                    HStack {
                        Spacer()
                        Text("Send Feedback")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(name.isEmpty || email.isEmpty || message.isEmpty)
            }
        }
        .navigationTitle("Contact Support")
        .sheet(isPresented: $showMailComposer) {
            MailComposerView(
                to: Constants.supportEmail,
                subject: "QuoteSnap Feedback (v\(Constants.appVersion))",
                body: "Name: \(name)\nEmail: \(email)\n\n\(message)"
            ) { result in
                switch result {
                case .success:
                    showSuccessAlert = true
                case .failure(let error):
                    mailError = error.localizedDescription
                }
            }
        }
        .alert("Thank You!", isPresented: $showSuccessAlert) {
            Button("OK") {
                name = ""
                email = ""
                message = ""
            }
        } message: {
            Text("Your feedback has been sent. We'll get back to you soon.")
        }
        .alert("Error", isPresented: .constant(mailError != nil)) {
            Button("OK") { mailError = nil }
        } message: {
            Text(mailError ?? "")
        }
    }

    private func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            showMailComposer = true
        } else {
            let mailtoString = "mailto:\(Constants.supportEmail)?subject=QuoteSnap Feedback&body=Name: \(name)%0AEmail: \(email)%0A%0A\(message)"
            if let url = URL(string: mailtoString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                UIApplication.shared.open(url)
            }
            showSuccessAlert = true
        }
    }
}

struct MailComposerView: UIViewControllerRepresentable {
    let to: String
    let subject: String
    let body: String
    let completion: (Result<Void, Error>) -> Void

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.setToRecipients([to])
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        composer.mailComposeDelegate = context.coordinator
        return composer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let completion: (Result<Void, Error>) -> Void

        init(completion: @escaping (Result<Void, Error>) -> Void) {
            self.completion = completion
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
