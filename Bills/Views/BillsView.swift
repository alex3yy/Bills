//
//  BillsView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillsView: View {
    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    @State private var isLoadingBills: Bool = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List(billsModel.bills) { bill in
                Button {
                    path.append(bill)
                } label: {
                    BillView(bill: bill, userId: billsModel.user?.id ?? "") {
                        try await billsModel.payBill(billId: bill.id)
                        try await billsModel.getBills()
                    }
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button {
                        navigationModel.presentConnectionsListView(for: bill)
                    } label: {
                        Label("Share with...", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .navigationDestination(for: Bill.self) { bill in
                Text("Bill Detail View")
            }
            .navigationTitle("Bills")
            .animation(.default, value: billsModel.bills)
            .task {
                isLoadingBills = true
                await getBills()
                isLoadingBills = false
            }
            .refreshable {
                await getBills()
            }
            .overlay {
                if isLoadingBills {
                    ProgressView()
                } else if billsModel.bills.isEmpty {
                    Text("You have no bills yet.")
                        .foregroundColor(.secondary)
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
    }

    private func getBills() async {
        do {
            try await billsModel.getBills()
        } catch {
            isLoadingBills = false
            print(error)
        }
    }
}

struct BillsView_Previews: PreviewProvider {
    static var previews: some View {
        BillsView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
