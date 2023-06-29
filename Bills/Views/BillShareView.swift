//
//  BillShareView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillShareView: View {
    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    var bill: Bill

    @State private var searchText: String = ""
    @State private var isLoadingConnections: Bool = false
    @State private var isSharingBill: Bool = false

    @State private var selectedConnections: [Connection.ID: Bool] = [:]

    var filteredConnections: [Connection] {
        guard !searchText.isEmpty else {
            return billsModel.connections
        }

        return billsModel.connections.filter { connection in
            connection.user.name.contains(searchText)
        }
    }

    var body: some View {
        Group {
            if filteredConnections.isEmpty {
                Text("You do not have any connections to share your bill with.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            } else {
                List {
                    ForEach(filteredConnections) { connection in
                        ConnectionShareCell(connection: connection, isShared: shareBinding(for: connection.id))
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .task {
            await getUserConnections()
            markSharingConnections()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", role: .cancel) {
                    navigationModel.dismissConnectionsListView()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save", role: .cancel) {
                    shareBill(with: Array(selectedConnections.filter({$0.value == true}).keys))
                }
            }
        }
        .disabled(isSharingBill)
    }

    private func markSharingConnections() {
        for connection in billsModel.connections {
            if bill.viewersIds.contains(connection.id) {
                selectedConnections[connection.id] = true
            } else {
                selectedConnections[connection.id] = false
            }
        }
    }

    private func getUserConnections() async {
        do {
            isLoadingConnections = true
            try await billsModel.getUserConnections()
            isLoadingConnections = false
        } catch {
            isLoadingConnections = false
            print(error)
        }
    }

    private func shareBill(with connectionIds: [Connection.ID]) {
        Task {
            do {
                isSharingBill = true
                try await billsModel.shareBill(connectionIds: connectionIds, billId: bill.id)
                isSharingBill = false
                try await billsModel.getBills()
                navigationModel.dismissConnectionsListView()
            } catch {
                isSharingBill = false
                print(error)
            }
        }
    }

    private func shareBinding(for connectionId: Connection.ID) -> Binding<Bool> {
        Binding {
            selectedConnections[connectionId] ?? false
        } set: { newValue in
            selectedConnections[connectionId] = newValue
        }
    }
}

struct BillShareView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BillShareView(bill: Bill(id: "1"))
        }
        .environmentObject(BillsModel(gateway: .remote))
        .environmentObject(NavigationModel())
    }
}
