//
//  ConnectionsView.swift
//  Bills
//
//  Created by Alex Zaharia on 28.05.2023.
//

import SwiftUI

struct ConnectionsView: View {

    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    @State private var isLoadingConnections: Bool = false

    private var tenants: [Connection] {
        billsModel.connections.filter(\.isTenant)
    }

    private var landlords: [Connection] {
        billsModel.connections.filter(\.isLandlord)
    }

    var body: some View {
        NavigationStack {
            List {
                if !tenants.isEmpty {
                    Section("Tenants") {
                        ForEach(tenants) { tenant in
                            PersonCardView(user: tenant.user)
                        }
                        .onDelete(perform: deleteConnections)
                    }
                }

                if !landlords.isEmpty {
                    Section("Landlords") {
                        ForEach(landlords) { landlord in
                            PersonCardView(user: landlord.user)
                        }
                        .onDelete(perform: deleteConnections)
                    }
                }
            }
            .navigationTitle("Connections")
            .animation(.default, value: isLoadingConnections)
            .overlay {
                VStack {
                    if isLoadingConnections {
                        ProgressView()
                    } else if billsModel.connections.isEmpty {
                        Text("You have no connections yet.")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .task {
                isLoadingConnections = true
                await getUserConnections()
                isLoadingConnections = false
            }
            .refreshable {
                await getUserConnections()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigationModel.presentUserInvitationsListView()
                    } label: {
                        Label("Bell", systemImage: "bell")
                            .labelStyle(.iconOnly)
                            .iconBadge(billsModel.activeInvitationsCount)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigationModel.presentAddConnectionsView()
                    } label: {
                        Label("Plus", systemImage: "person.badge.plus")
                            .labelStyle(.iconOnly)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $navigationModel.isPresentingAddConnectionsView) {
            NavigationStack {
                UserConnectionSearchView()
                    .navigationTitle("Add Connection")
            }
        }
        .sheet(isPresented: $navigationModel.isPresentingUserInvitationsListView) {
            NavigationStack {
                UserInvitationsListView()
                    .navigationTitle("Invitations")
            }
        }
    }

    private func getUserConnections() async {
        do {
            try await billsModel.getUserConnections()
        } catch {
            print(error)
        }
    }

    private func deleteConnections(atOffsets indexSet: IndexSet) {
        Task {
            do {
                try await billsModel.deleteUserConnections(atOffsets: indexSet)
            } catch {
                print(error)
            }
        }
    }
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
