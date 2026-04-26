import SwiftUI

struct TemplatePicker: View {
    @Binding var selectedTemplate: TemplateType
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(TemplateType.allCases, id: \.self) { template in
                TemplateCard(template: template, isSelected: selectedTemplate == template)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTemplate = template
                        }
                    }
            }
        }
    }
}

struct TemplateCard: View {
    let template: TemplateType
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: TemplateService.templateIcons[template] ?? "doc.fill")
                .font(.title2)
                .foregroundColor(Color(hex: TemplateService.templateColors[template] ?? "6B7280"))
                .frame(height: 28)

            Text(template.rawValue)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(isSelected ? Color(hex: TemplateService.templateColors[template] ?? "6B7280").opacity(0.12) : Color.bgLight)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color(hex: TemplateService.templateColors[template] ?? "6B7280") : Color.clear, lineWidth: 2)
        )
    }
}
