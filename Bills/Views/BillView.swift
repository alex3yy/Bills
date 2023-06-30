//
//  BillView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillView: View {

    var bill: Bill
    var userId: User.ID
    var payAction: () async throws -> Void

    @State private var isPayingBill: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    BillPaymentStatusLabel(dueDate: bill.dueDate, paymentStatus: bill.paymentStatus)

                    Text(bill.provider.rawValue.capitalized)
                        .font(.headline)

                    if bill.isShared {
                        Group {
                            if bill.isOwner(userId: userId) {
                                Text("Shared with \(bill.viewersCount) user(s)")
                            } else {
                                Text("Shared by \(bill.client.name)")
                            }
                        }
                        .font(.caption)
                        .italic()
                        .foregroundColor(.secondary)
                    }
                }

                VStack(alignment: .leading) {
                    ForEach(bill.services) { service in
                        Text(service.title)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(bill.price, format: .currency(code: "RON"))

                if !bill.isPaid {
                    Button {
                        payBill()
                    } label: {
                        Text("Pay")
                    }
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .contentShape(Rectangle())
    }

    private func payBill() {
        Task {
            do {
                isPayingBill = true
                try await payAction()
                isPayingBill = false
            } catch {
                isPayingBill = false
                print(error
                )
            }
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView(bill: Bill(
            id: "1",
            client: .init(id: "u1", name: "John Appleseed"),
            provider: .digi,
            services: [
                .init(id: "s1", title: "Serv. reparatii", price: 20, currencyCode: "RON")
            ],
            currencyCode: "RON"), userId: "u2", payAction: {})
    }
}
