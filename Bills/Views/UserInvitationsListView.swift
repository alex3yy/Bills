//
//  UserInvitationsListView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct UserInvitationsListView: View {
    @EnvironmentObject private var billsModel: BillsModel

    @State private var isLoadingInvitations: Bool = false

    private var sentInvitations: [Invitation] {
        billsModel.invitations.filter(\.isSent)
    }

    private var receivedInvitations: [Invitation] {
        billsModel.invitations.filter(\.isReceived)
    }

    var body: some View {
        VStack {
            if isLoadingInvitations {
                ProgressView()
            } else {
                if billsModel.invitations.isEmpty {
                    Text("There are no invitations yet.")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        if !receivedInvitations.isEmpty {
                            Section("Received") {
                                ForEach(receivedInvitations) { invitation in
                                    UserInvitationView(invitation: invitation) {
                                        //
                                    } deleteAction: {
                                        try await deleteInvitation(for: invitation.user.id)
                                    }

                                }
                            }
                        }

                        if !sentInvitations.isEmpty {
                            Section("Sent") {
                                ForEach(sentInvitations) { invitation in
                                    UserInvitationView(invitation: invitation, deleteAction: {
                                        try await deleteInvitation(for: invitation.user.id)
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            getUserInvitations()
        }
    }

    private func getUserInvitations() {
        Task {
            do {
                isLoadingInvitations = true
                try await billsModel.getUserInvitations()
                isLoadingInvitations = false
            } catch {
                isLoadingInvitations = false
                print(error)
            }
        }
    }

    private func deleteInvitation(for id: User.ID) async throws {
        try await billsModel.deleteUserInvitation(for: id)
        getUserInvitations()
    }
}

struct UserInvitationsListView_Previews: PreviewProvider {
    static var previews: some View {
        UserInvitationsListView()
            .environmentObject(BillsModel(gateway: .remote))
    }
}
