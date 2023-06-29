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

    var body: some View {
        NavigationStack {
            List {
                ForEach(billsModel.bills) { bill in
                    NavigationLink {
                        Text("Bill Detail View")
                    } label: {
                        BillView(bill: bill)
                    }
                    .contextMenu {
                        Button {
                            navigationModel.presentConnectionsListView(for: bill)
                        } label: {
                            Label("Share with...", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .navigationTitle("Bills")
            .task {
                getBills()
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

    private func getBills() {
        Task {
            do {
                isLoadingBills = true
                try await billsModel.getBills()
                isLoadingBills = false
            } catch {
                isLoadingBills = false
                print(error)
            }
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
