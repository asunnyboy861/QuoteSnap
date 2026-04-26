import SwiftUI
import SwiftData
import PhotosUI

struct BrandingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var businessInfos: [BusinessInfo]
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    @State private var brandColorHex = "#1270C4"
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var logoImage: UIImage?
    @State private var showColorPicker = false

    var body: some View {
        Form {
            Section(header: Text("Company Details")) {
                TextField("Business Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
            }

            Section(header: Text("Address")) {
                TextField("Street", text: $street)
                HStack {
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                        .frame(width: 60)
                }
                TextField("ZIP", text: $zip)
            }

            Section(header: Text("Logo")) {
                HStack {
                    if let logoImage = logoImage {
                        Image(uiImage: logoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.bgLight)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.textSecondary)
                            )
                    }

                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Text("Choose Logo")
                            .font(.subheadline)
                            .foregroundColor(.trustBlue)
                    }
                }
            }

            Section(header: Text("Brand Color")) {
                HStack {
                    Circle()
                        .fill(Color(hex: brandColorHex))
                        .frame(width: 36, height: 36)
                    Text(brandColorHex)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Button("Change") {
                        showColorPicker = true
                    }
                    .foregroundColor(.trustBlue)
                }
            }
        }
        .navigationTitle("Company & Branding")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveBusinessInfo() }
                    .fontWeight(.bold)
            }
        }
        .onAppear {
            if let info = businessInfos.first {
                name = info.name
                email = info.email
                phone = info.phone
                street = info.street
                city = info.city
                state = info.state
                zip = info.zip
                brandColorHex = info.brandColorHex
                if let logoData = info.logoData {
                    logoImage = UIImage(data: logoData)
                }
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    logoImage = image
                }
            }
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPickerSheet(selectedHex: $brandColorHex)
        }
    }

    private func saveBusinessInfo() {
        let logoData = logoImage?.jpegData(compressionQuality: 0.8)
        if let info = businessInfos.first {
            info.name = name
            info.email = email
            info.phone = phone
            info.street = street
            info.city = city
            info.state = state
            info.zip = zip
            info.brandColorHex = brandColorHex
            info.logoData = logoData
            info.updatedAt = Date()
        } else {
            let newInfo = BusinessInfo(name: name, email: email, phone: phone, street: street, city: city, state: state, zip: zip, logoData: logoData, brandColorHex: brandColorHex)
            modelContext.insert(newInfo)
        }
        try? modelContext.save()
    }
}

struct ColorPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedHex: String
    @State private var color = Color.trustBlue
    let presetColors = ["#1270C4", "#2E9E8A", "#38BA59", "#FF9C1E", "#E63838", "#8B5CF6", "#EC4899", "#1F2937"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ColorPicker("Pick a color", selection: $color, supportsOpacity: false)
                    .padding()

                Text("Preset Colors")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(presetColors, id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle().stroke(selectedHex == hex ? Color.white : Color.clear, lineWidth: 3)
                            )
                            .shadow(radius: selectedHex == hex ? 4 : 0)
                            .onTapGesture {
                                selectedHex = hex
                                color = Color(hex: hex)
                            }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Brand Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        selectedHex = color.toHex()
                        dismiss()
                    }
                }
            }
        }
    }
}

extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
