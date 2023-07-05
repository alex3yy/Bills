//
//  BillsView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

enum BillsDisplayType {
    case all
    case shared
}

struct BillsView: View {
    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    @State private var isLoadingBills: Bool = false
    @State private var path = NavigationPath()

    @State private var billsDisplayType: BillsDisplayType = .all

    private var bills: [Bill] {
        switch billsDisplayType {
        case .all:
            return billsModel.bills
        case .shared:
            return billsModel.bills.filter(\.isShared)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            List(bills) { bill in
                Button {
                    path.append(bill)
                } label: {
                    BillView(bill: bill, userId: billsModel.user?.id ?? "") {
                        try await payBill(billId: bill.id)
                    }
                }
                .buttonStyle(.plain)
                .contextMenu {
                    if bill.isOwner(userId: billsModel.user?.id ?? "") {
                        Button {
                            navigationModel.presentConnectionsListView(for: bill)
                        } label: {
                            Label("Share with...", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .navigationDestination(for: Bill.self) { bill in
                BillDetailView(bill: bill, userId: billsModel.user?.id ?? "") {
                    navigationModel.presentConnectionsListView(for: bill)
                } payAction: {
                    try await payBill(billId: bill.id)
                }
            }
            .navigationTitle("Bills")
            .animation(.default, value: bills)
            .task {
                isLoadingBills = true
                await getBills()
                isLoadingBills = false
            }
            .refreshable {
                await getBills()
            }
            .overlay {
                VStack {
                    if isLoadingBills {
                        ProgressView()
                    } else if bills.isEmpty {
                        Text("You have no bills yet.")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigationModel.presentAddBillView()
                    } label: {
                        Label("Plus", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Picker("What is your favorite color?", selection: $billsDisplayType) {
                        Text("All").tag(BillsDisplayType.all)
                        Text("Shared").tag(BillsDisplayType.shared)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
            }
        }
        .sheet(item: $navigationModel.selectedBillForSharing) { bill in
            NavigationStack {
                BillShareView(bill: bill)
                    .navigationTitle("Share Bill")
            }
        }
        .sheet(isPresented: $navigationModel.isPresentingAddBillView) {
            NavigationStack {
                AddBillView()
                    .navigationTitle("Add Bill")
            }
        }
    }

    private func getBills() async {
        do {
            try await billsModel.getBills()
        } catch {
            isLoadingBills = false
            print(error)
        }
    }

    private func payBill(billId: Bill.ID) async throws {
        try await billsModel.payBill(billId: billId)
        try await billsModel.getBills()
    }
}

struct BillsView_Previews: PreviewProvider {
    static var previews: some View {
        BillsView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
