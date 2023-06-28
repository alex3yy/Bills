//
//  UserConnectionSearchView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

enum UserConnectionStatus {
    case sentInvite
    case connected
    case receivedInvite
    case unrelated
}

struct UserConnectionSearchView: View {
    @EnvironmentObject private var billsModel: BillsModel

    @State private var searchText: String = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var isSearching: Bool = false

    @State private var isSendingInvite: Bool = false

    @State private var userConnectionStatus: UserConnectionStatus?
    //@State private var isInvited: Bool?

    //@State private var isConnected: Bool?

//    @State private var matchingUser: User?

    var invitationStatus: Invitation.Status? {
        billsModel.invitations.first(where: { $0.user.id == searchText }).map(\.status)
    }

    var body: some View {
        Group {
            if isSearching {
                ProgressView()
            } else {
                if searchText.isEmpty {
                    Text("Search for a user in order to invite him to join your managed domain.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                } else {
                    if let matchingUser = billsModel.searchedUser {
                        List {
                            HStack {
                                PersonCardView(user: matchingUser)

                                Spacer()

                                if let userConnectionStatus {
                                    switch userConnectionStatus {
                                    case .sentInvite:
                                        Text("Invited")
                                            .foregroundColor(.secondary)
                                    case .connected:
                                        Text("Connected")
                                            .foregroundColor(.secondary)
                                    case .receivedInvite:
                                        Text("Invited you")
                                            .foregroundColor(.secondary)
                                    case .unrelated:
                                        Button {
                                            inviteUser(with: matchingUser.id)
                                        } label: {
                                            Text("Invite")
                                                .opacity(isSendingInvite ? 0 : 1)
                                                .overlay {
                                                    if isSendingInvite {
                                                        ProgressView()
                                                    }
                                                }
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .disabled(isSendingInvite)
                                    }
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                    } else {
                        Text("No user was found with the provided id.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            performSearch()
        }
        .onSubmit {
            performSearch()
        }
    }

    private func performSearch() {

        // Remove previous state.
        userConnectionStatus = nil

        // Cancel previous task.
        searchTask?.cancel()

        guard !searchText.isEmpty else {
            return
        }

        searchTask = Task {
            do {
                isSearching = true
                try await Task.sleep(for: .seconds(2))
                try await billsModel.searchUser(for: searchText)
                try await getUserConnectionStatus()
                isSearching = false
            } catch {
                isSearching = false
                print(error)
            }
        }
    }

    private func getUserConnectionStatus() async throws {
        let invitationStatus = try await billsModel.invitedUser(for: searchText)
        let isConnected = try await billsModel.connectedUser(for: searchText)

        if let invitationStatus {
            switch invitationStatus {
            case .sent:
                userConnectionStatus = .sentInvite
            case .received:
                userConnectionStatus = .receivedInvite
            }
        } else if isConnected {
            userConnectionStatus = .connected
        } else {
            userConnectionStatus = .unrelated
        }
    }

    private func inviteUser(with id: User.ID) {
        Task {
            do {
                isSendingInvite = true
                try await billsModel.inviteUser(with: id)
                try await getUserConnectionStatus()
                isSendingInvite = false
            } catch {
                isSendingInvite = false
                print(error)
            }
        }
    }
}

struct UserConnectionSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserConnectionSearchView()
                .environmentObject(BillsModel(gateway: .remote))
        }
    }
}
