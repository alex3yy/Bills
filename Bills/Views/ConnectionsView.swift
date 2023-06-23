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

    @State private var range1: [Int] = [0, 1, 2, 3, 4]
    @State private var range2: [Int] = [5, 6, 7, 8, 9]

    let mockedNames = [
        "John Appleseed",
        "Jane Doe",
        "Mason Hugh",
        "Martin Fowler",
        "Dwayne Johnson",
        "Mark Lee",
        "Emily Duncan",
        "Natalie Gurman",
        "Tim Cook",
        "George Beto"
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Tenants") {
                    ForEach(range1, id: \.self) { index in
                        PersonCardView(user: User(id: "\(index)", name: mockedNames[index]))
                    }
                    .onDelete { range1.remove(atOffsets: $0) }
                }

                Section("Landlords") {
                    ForEach(range2, id: \.self) { index in
                        PersonCardView(user: User(id: "\(index)", name: mockedNames[index]))
                    }
                    .onDelete { range2.remove(atOffsets: $0) }
                }
            }
            .navigationTitle("Connections")
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
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
