//
//  BillDetailView.swift
//  Bills
//
//  Created by Alex Zaharia on 30.06.2023.
//

import SwiftUI

struct BillDetailView: View {

    var bill: Bill
    var userId: User.ID
    var shareAction: () -> Void
    var payAction: () async throws -> Void

    @State private var isPayingBill: Bool = false
    @State private var isPaymentSuccessful: Bool = false

    var body: some View {
        Form {
            Section {
                LabeledContent("Status", value: bill.paymentStatus.rawValue.capitalized)
                    .foregroundColor(labelStatusColor)
                LabeledContent("Due Date", value: bill.dueDate.formatted(.dateTime.day().month().year()))
            }

            Section("Provider") {
                LabeledContent("Name", value: bill.provider.rawValue.capitalized)
                    .labelsHidden()
            }

            Section("Client") {
                LabeledContent("Name", value: bill.client.name)
                LabeledContent("Identifier", value: bill.client.id)
            }

            Section("Services") {
                ForEach(bill.services) { service in
                    LabeledContent(service.title, value: service.price, format: .currency(code: "RON"))
                }
            }
            Section {
                LabeledContent("Total", value: bill.price, format: .currency(code: "RON"))
            }

            if !isPaymentSuccessful && !bill.isPaid {
                Button {
                    payBill()
                } label: {
                    HStack {
                        Text("Pay Bill")

                        Spacer()

                        if isPayingBill {
                            ProgressView()
                        }
                    }
                }
            }
        }
        .animation(.default, value: isPaymentSuccessful)
        .navigationTitle("Details")
        .toolbar {
            if bill.isOwner(userId: userId) {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        shareAction()
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .disabled(isPayingBill)
    }

    private func payBill() {
        Task {
            do {
                isPayingBill = true
                try await payAction()
                isPaymentSuccessful = true
                isPayingBill = false
            } catch {
                isPayingBill = false
                print(error
                )
            }
        }
    }

    private var labelStatusColor: Color {
        switch bill.paymentStatus {
        case .paid:
            return .green
        case .unpaid:
            return .red
        case .due:
            return .orange
        }
    }
}

struct BillDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BillDetailView(
            bill: Bill(
                id: "1",
                client: .init(id: "u1", name: "John Appleseed"),
                provider: .digi,
                services: [
                    .init(id: "s1", title: "Serv. reparatii", price: 20, currencyCode: "RON")
                ],
                currencyCode: "RON"),
            userId: "u2",
            shareAction: {},
            payAction: {}
        )
    }
}
