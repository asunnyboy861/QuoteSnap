import SwiftUI

struct StatusBadge: View {
    let status: QuoteStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.15))
            .foregroundColor(statusColor)
            .cornerRadius(6)
    }

    private var statusColor: Color {
        switch status {
        case .draft: return .textSecondary
        case .sent: return .trustBlue
        case .accepted: return .successGreen
        case .declined: return .dangerRed
        case .expired: return .warmOrange
        }
    }
}

struct InvoiceStatusBadge: View {
    let status: InvoiceStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.15))
            .foregroundColor(statusColor)
            .cornerRadius(6)
    }

    private var statusColor: Color {
        switch status {
        case .pending: return .warmOrange
        case .paid: return .successGreen
        case .overdue: return .dangerRed
        case .cancelled: return .textSecondary
        }
    }
}
