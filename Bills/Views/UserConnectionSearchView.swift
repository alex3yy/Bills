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

                                } label: {
                                    Text("Invite")
                                }
                                .buttonStyle(.borderedProminent)
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
}

struct UserConnectionSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserConnectionSearchView()
                .environmentObject(BillsModel(gateway: .remote))
        }
    }
}
