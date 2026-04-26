import SwiftUI
import SwiftData
import ContactsUI

struct ClientFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let client: Client?

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var company = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    @State private var notes = ""
    @State private var showContactPicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Contact Info")) {
                    HStack {
                        TextField("Name", text: $name)
                        Button(action: { showContactPicker = true }) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .foregroundColor(.trustBlue)
                        }
                    }
                    TextField("Company", text: $company)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                }

                Section(header: Text("Address")) {
                    TextField("Street", text: $street)
                    HStack {
                        TextField("City", text: $city)
                        TextField("State", text: $state)
                            .frame(width: 60)
                    }
                    TextField("ZIP", text: $zip)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 80)
                }
            }
            .navigationTitle(client == nil ? "New Client" : "Edit Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveClient() }
                        .fontWeight(.bold)
                        .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let client = client {
                    name = client.name
                    email = client.email
                    phone = client.phone
                    company = client.company
                    street = client.street
                    city = client.city
                    state = client.state
                    zip = client.zip
                    notes = client.notes
                }
            }
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView { contact in
                    name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                    email = contact.emailAddresses.first?.value as String? ?? ""
                    phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                    company = contact.organizationName
                    let postal = contact.postalAddresses.first?.value
                    street = postal?.street ?? ""
                    city = postal?.city ?? ""
                    state = postal?.state ?? ""
                    zip = postal?.postalCode ?? ""
                }
            }
        }
    }

    private func saveClient() {
        if let client = client {
            client.name = name
            client.email = email
            client.phone = phone
            client.company = company
            client.street = street
            client.city = city
            client.state = state
            client.zip = zip
            client.notes = notes
        } else {
            let newClient = Client(name: name, email: email, phone: phone, company: company, street: street, city: city, state: state, zip: zip, notes: notes)
            modelContext.insert(newClient)
        }
        try? modelContext.save()
        dismiss()
    }
}

struct ContactPickerView: UIViewControllerRepresentable {
    let onSelect: (CNContact) -> Void

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onSelect: onSelect)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        let onSelect: (CNContact) -> Void

        init(onSelect: @escaping (CNContact) -> Void) {
            self.onSelect = onSelect
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            onSelect(contact)
        }
    }
}
