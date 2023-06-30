//
//  BillPaymentStatusLabel.swift
//  Bills
//
//  Created by Alex Zaharia on 30.06.2023.
//

import SwiftUI

struct BillPaymentStatusLabel: View {
    
    let dueDate: Date
    let paymentStatus: Bill.PaymentStatus
    
    var body: some View {
        Label {
            Text(labelTitle)
        } icon: {
            Image(systemName: labelIcon)
        }
        .labelStyle(.titleAndIcon)
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.horizontal, 4)
        .padding(.trailing, 2)
        .padding(.vertical, 2)
        .background(labelBackgroundColor, in: Capsule())
    }

    var labelIcon: String {
        switch paymentStatus {
        case .paid:
            return "checkmark.circle"
        case .unpaid:
            return "clock.badge.xmark"
        case .due:
            return "clock"
        }
    }

    var labelTitle: LocalizedStringKey {
        switch paymentStatus {
        case .paid:
            return "Paid"
        case .unpaid:
            return "Unpaid"
        case .due:
            return "Due by \(dueDate.formatted(.dateTime.day(.defaultDigits).month(.abbreviated)))"
        }
    }

    var labelBackgroundColor: Color {
        switch paymentStatus {
        case .paid:
            return .green
        case .unpaid:
            return .red
        case .due:
            return .orange
        }
    }
}

struct BillPaymentStatusLabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BillPaymentStatusLabel(dueDate: Date() + 100000, paymentStatus: .paid)
            BillPaymentStatusLabel(dueDate: Date() + 100000, paymentStatus: .unpaid)
            BillPaymentStatusLabel(dueDate: Date() + 100000, paymentStatus: .due)
        }
    }
}
