//
//  AddBillView.swift
//  Bills
//
//  Created by Alex Zaharia on 28.06.2023.
//

import SwiftUI

struct AddBillView: View {

    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    @State private var bill = Bill()
    @State private var isAddingBill: Bool = false

    var user: User? {
        billsModel.user
    }

    var body: some View {
        Form {
            Section {
                Picker("Provider", selection: $bill.provider) {
                    ForEach(Bill.Provider.allCases) { provider in
                        Text(provider.rawValue.capitalized).tag(provider)
                    }
                }
                .pickerStyle(.navigationLink)
            }

            Section("Client") {
                LabeledContent("Name", value: bill.client.name)
                LabeledContent("Identifier", value: bill.client.id)
            }

            Section {
                ForEach($bill.services) { service in
                    LabeledContent {
                        TextField("", value: service.price, format: .currency(code: "RON"))
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                    } label: {
                        TextField("", text: service.title, prompt: Text("Service Name..."), axis: .vertical)
                            .frame(alignment: .leading)
                            .lineLimit(2)
                    }
                }
            } header: {
                Text("Services")
            } footer: {
                Button {
                    bill.addNewService()
                } label: {
                    Label("Service", systemImage: "plus")
                        .foregroundColor(.accentColor)
                }
                .tint(.white)
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
            }

            Section {
                LabeledContent("Total", value: bill.price, format: .currency(code: "RON"))
            }

            Button {
                bill.generateRandomBill()
            } label: {
                Text("Generate bill")
            }
        }
        .task {
            bill.client.id = user?.id ?? ""
            bill.client.name = user?.name ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    addBill()
                } label: {
                    Text("Add")
                        .opacity(isAddingBill ? 0 : 1)
                        .overlay {
                            if isAddingBill {
                                ProgressView()
                            }
                        }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", role: .cancel) {
                    navigationModel.dismissAddBillView()
                }
            }
        }
        .disabled(isAddingBill)
    }

    private func addBill() {
        Task {
            do {
                isAddingBill = true
                bill.services.removeAll(where: { $0.title.isEmpty })
                bill.roundPrices()
                try await billsModel.addBill(bill)
                isAddingBill = false
                navigationModel.dismissAddBillView()
                try await billsModel.getBills()
            } catch {
                isAddingBill = false
                print(error)
            }
        }
    }
}

struct AddBillView_Previews: PreviewProvider {
    static var previews: some View {
        AddBillView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
