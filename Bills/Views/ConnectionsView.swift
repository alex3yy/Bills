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

    var body: some View {
        NavigationStack {
            Text("Connections List View")
            .navigationTitle("Connections")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //
                    } label: {
                        Label("Bell", systemImage: "bell")
                            .labelStyle(.iconOnly)
                            .overlay(alignment: .topTrailing) {
                                Text(billsModel.activeInvitationsCount.formatted())
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(.red)
                                    .clipShape(Circle())
                                    .offset(x: 4, y: -6)
                            }
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
