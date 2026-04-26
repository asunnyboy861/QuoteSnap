import UIKit
import PDFKit

struct PDFGenerator {
    static func generateQuotePDF(quote: Quote, businessInfo: BusinessInfo) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        let contentWidth = pageWidth - margin * 2

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        let data = renderer.pdfData { context in
            context.beginPage()
            var y: CGFloat = margin

            if let logoData = businessInfo.logoData, let logoImage = UIImage(data: logoData) {
                let logoSize = CGSize(width: 80, height: 80)
                logoImage.draw(in: CGRect(origin: CGPoint(x: margin, y: y), size: logoSize))
                let infoX = margin + logoSize.width + 20
                drawText(businessInfo.name, at: CGPoint(x: infoX, y: y + 5), font: .boldSystemFont(ofSize: 18), color: UIColor(hex: businessInfo.brandColorHex) ?? .black)
                drawText(businessInfo.phone, at: CGPoint(x: infoX, y: y + 28), font: .systemFont(ofSize: 11), color: .gray)
                drawText(businessInfo.email, at: CGPoint(x: infoX, y: y + 44), font: .systemFont(ofSize: 11), color: .gray)
                let addressLine = "\(businessInfo.city), \(businessInfo.state) \(businessInfo.zip)"
                drawText(addressLine, at: CGPoint(x: infoX, y: y + 60), font: .systemFont(ofSize: 11), color: .gray)
                y += logoSize.height + 20
            } else {
                drawText(businessInfo.name, at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 22), color: UIColor(hex: businessInfo.brandColorHex) ?? .black)
                y += 30
                drawText(businessInfo.phone, at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 11), color: .gray)
                drawText(businessInfo.email, at: CGPoint(x: margin + 150, y: y), font: .systemFont(ofSize: 11), color: .gray)
                y += 20
            }

            drawLine(from: CGPoint(x: margin, y: y), to: CGPoint(x: pageWidth - margin, y: y), color: UIColor(hex: businessInfo.brandColorHex) ?? .black, width: 2)
            y += 20

            drawText("QUOTE", at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 28), color: UIColor(hex: businessInfo.brandColorHex) ?? .black)
            drawText(quote.number, at: CGPoint(x: pageWidth - margin - 120, y: y), font: .boldSystemFont(ofSize: 16), color: .darkGray, alignment: .right, width: 120)
            y += 35

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium

            drawText("Date: \(dateFormatter.string(from: quote.date))", at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 12), color: .darkGray)
            if let validUntil = quote.validUntil {
                drawText("Valid Until: \(dateFormatter.string(from: validUntil))", at: CGPoint(x: margin + 200, y: y), font: .systemFont(ofSize: 12), color: .darkGray)
            }
            y += 25

            if let client = quote.client {
                drawText("Bill To:", at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 11), color: .gray)
                y += 16
                drawText(client.name, at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 14), color: .black)
                y += 18
                if !client.company.isEmpty {
                    drawText(client.company, at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 12), color: .darkGray)
                    y += 16
                }
                if !client.street.isEmpty {
                    drawText(client.street, at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 11), color: .darkGray)
                    y += 15
                }
                let cityLine = "\(client.city), \(client.state) \(client.zip)"
                if !client.city.isEmpty {
                    drawText(cityLine, at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 11), color: .darkGray)
                    y += 15
                }
            }
            y += 15

            let colX = [margin, margin + 250, margin + 350, margin + 420, margin + 490]
            let _: [CGFloat] = [250, 100, 70, 70, 72]
            let headerHeight: CGFloat = 28

            (UIColor(hex: businessInfo.brandColorHex) ?? .black).setFill()
            let headerRect = CGRect(x: margin, y: y, width: contentWidth, height: headerHeight)
            context.cgContext.fill(headerRect)

            let headers = ["Description", "Qty", "Unit", "Price", "Total"]
            for i in 0..<headers.count {
                drawText(headers[i], at: CGPoint(x: colX[i] + 8, y: y + 7), font: .boldSystemFont(ofSize: 11), color: .white)
            }
            y += headerHeight

            let items = quote.items
            for item in items {
                let rowHeight: CGFloat = 22
                if y + rowHeight > pageHeight - 150 {
                    context.beginPage()
                    y = margin
                }
                drawText(item.description, at: CGPoint(x: colX[0] + 8, y: y + 5), font: .systemFont(ofSize: 11), color: .black)
                drawText(String(format: "%.0f", item.quantity), at: CGPoint(x: colX[1] + 8, y: y + 5), font: .systemFont(ofSize: 11), color: .darkGray)
                drawText(item.unit, at: CGPoint(x: colX[2] + 8, y: y + 5), font: .systemFont(ofSize: 11), color: .darkGray)
                drawText(formatCurrency(item.unitPrice), at: CGPoint(x: colX[3] + 8, y: y + 5), font: .systemFont(ofSize: 11), color: .darkGray)
                drawText(formatCurrency(item.total), at: CGPoint(x: colX[4] + 8, y: y + 5), font: .systemFont(ofSize: 11), color: .black)
                y += rowHeight
            }

            y += 10
            drawLine(from: CGPoint(x: margin, y: y), to: CGPoint(x: pageWidth - margin, y: y), color: .lightGray, width: 0.5)
            y += 15

            let rightX = pageWidth - margin - 200
            let valueX = pageWidth - margin
            drawText("Subtotal:", at: CGPoint(x: rightX, y: y), font: .systemFont(ofSize: 12), color: .darkGray, alignment: .right, width: 140)
            drawText(formatCurrency(quote.subtotal), at: CGPoint(x: valueX - 60, y: y), font: .systemFont(ofSize: 12), color: .black, alignment: .right, width: 60)
            y += 20

            if quote.discountValue > 0 {
                let discountLabel = quote.quoteDiscountType == .percentage ? "Discount (\(Int(quote.discountValue))%):" : "Discount:"
                drawText(discountLabel, at: CGPoint(x: rightX, y: y), font: .systemFont(ofSize: 12), color: .darkGray, alignment: .right, width: 140)
                let discountAmount = quote.quoteDiscountType == .percentage ? quote.subtotal * quote.discountValue / 100 : quote.discountValue
                drawText("-\(formatCurrency(discountAmount))", at: CGPoint(x: valueX - 60, y: y), font: .systemFont(ofSize: 12), color: .red, alignment: .right, width: 60)
                y += 20
            }

            if quote.taxRate > 0 {
                drawText("Tax (\(Int(quote.taxRate))%):", at: CGPoint(x: rightX, y: y), font: .systemFont(ofSize: 12), color: .darkGray, alignment: .right, width: 140)
                drawText(formatCurrency(quote.taxAmount), at: CGPoint(x: valueX - 60, y: y), font: .systemFont(ofSize: 12), color: .darkGray, alignment: .right, width: 60)
                y += 20
            }

            drawLine(from: CGPoint(x: rightX, y: y), to: CGPoint(x: valueX, y: y), color: .black, width: 1)
            y += 8
            drawText("TOTAL:", at: CGPoint(x: rightX, y: y), font: .boldSystemFont(ofSize: 16), color: UIColor(hex: businessInfo.brandColorHex) ?? .black, alignment: .right, width: 140)
            drawText(formatCurrency(quote.total), at: CGPoint(x: valueX - 80, y: y), font: .boldSystemFont(ofSize: 16), color: UIColor(hex: businessInfo.brandColorHex) ?? .black, alignment: .right, width: 80)
            y += 35

            if !quote.notes.isEmpty {
                drawText("Notes:", at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 11), color: .gray)
                y += 16
                drawText(quote.notes, at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 10), color: .darkGray, width: contentWidth)
                y += 30
            }

            if !quote.terms.isEmpty {
                drawText("Terms & Conditions:", at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 11), color: .gray)
                y += 16
                drawText(quote.terms, at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 10), color: .darkGray, width: contentWidth)
            }
        }

        return data
    }

    static func generateInvoicePDF(invoice: Invoice, businessInfo: BusinessInfo) -> Data {
        let tempQuote = Quote(
            number: invoice.number,
            date: invoice.date,
            validUntil: invoice.dueDate,
            status: .draft,
            items: invoice.items,
            subtotal: invoice.subtotal,
            taxRate: invoice.taxRate,
            taxAmount: invoice.taxAmount,
            discountType: invoice.invoiceDiscountType,
            discountValue: invoice.discountValue,
            total: invoice.total,
            notes: invoice.notes,
            terms: invoice.terms,
            templateType: invoice.invoiceTemplateType,
            client: invoice.client
        )
        return generateQuotePDF(quote: tempQuote, businessInfo: businessInfo)
    }

    private static func drawText(_ text: String, at point: CGPoint, font: UIFont, color: UIColor, alignment: NSTextAlignment = .left, width: CGFloat? = nil) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let textWidth = width ?? (612 - 100 - point.x)
        let rect = CGRect(x: point.x, y: point.y, width: textWidth, height: 100)
        let _ = NSAttributedString(string: text, attributes: attributes)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byWordWrapping

        let fullAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
        ]
        let fullAttrString = NSAttributedString(string: text, attributes: fullAttributes)
        fullAttrString.draw(in: rect)
    }

    private static func drawLine(from start: CGPoint, to end: CGPoint, color: UIColor, width: CGFloat = 1) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = width
        color.setStroke()
        path.stroke()
    }

    private static func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        guard hexSanitized.count == 6 else { return nil }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}
