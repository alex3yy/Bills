//
//  UserConnectionSearchView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct UserConnectionSearchView: View {
    @EnvironmentObject private var billsModel: BillsModel

    @State private var searchText: String = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var isSearching: Bool = false

    @State private var isSendingInvite: Bool = false
    @State private var isInvited: Bool = false

    @State private var matchingUser: User?

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

                                Button {
                                    inviteUser(with: matchingUser.id)
                                } label: {
                                    Text(!isInvited ? "Invite" : "Invited")
                                        .opacity(isSendingInvite ? 0 : 1)
                                        .overlay {
                                            if isSendingInvite {
                                                ProgressView()
                                            }
                                        }
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(isSendingInvite || isInvited)
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
        .navigationTitle("Add Connection")
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            performSearch()
        }
        .onSubmit {
            performSearch()
        }
    }

    private func performSearch() {

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
                isSearching = false
            } catch {
                isSearching = false
                print(error)
            }
        }
    }

    private func inviteUser(with id: User.ID) {
        Task {
            do {
                isSendingInvite = true
                try await billsModel.inviteUser(with: id)
                isSendingInvite = false
                isInvited = true
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
