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
            VStack {
                if isLoadingConnections {
                    ProgressView()
                } else {
                    if billsModel.connections.isEmpty {
                        Text("You have no connections yet.")
                            .foregroundColor(.secondary)
                    } else {
                        List {
                            if !tenants.isEmpty {
                                Section("Tenants") {
                                    ForEach(tenants) { tenant in
                                        PersonCardView(user: tenant.user)
                                    }
                                    //.onDelete {  }
                                }
                            }

                            if !landlords.isEmpty {
                                Section("Landlords") {
                                    ForEach(landlords) { landlord in
                                        PersonCardView(user: landlord.user)
                                    }
                                    //.onDelete {  }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Connections")
            .task {
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
            .sheet(isPresented: $navigationModel.isPresentingAddConnectionsView) {
                NavigationStack {
                    UserConnectionSearchView()
                        .navigationTitle("Add Connection")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done", role: .cancel) {
                                    navigationModel.dismissAddConnectionsView()
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $navigationModel.isPresentingUserInvitationsListView) {
                NavigationStack {
                    UserInvitationsListView()
                        .navigationTitle("Invitations")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done", role: .cancel) {
                                    navigationModel.dismissUserInvitationsListView()
                                }
                            }
                        }
                }
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
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
