//
//  UserConnectionSearchView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct UserConnectionSearchView: View {
    //@EnvironmentObject private var billsModel: BillsModel

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
                    if let matchingUser {
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
        searchTask?.cancel()

        searchTask = Task {
            isSearching = true
            try? await Task.sleep(for: .seconds(2))
            //billsModel.searchUser(using: searchText)
            isSearching = false
        }
    }
}

struct UserConnectionSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserConnectionSearchView()
        }
    }
}
