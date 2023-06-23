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

    let mockedNames = [
        "Ben Still",
        "Cristiano Ronaldo",
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
        Group {
            if searchText.isEmpty {
                Text("Search for a user in order to invite him to join your managed domain.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            } else {
                List {
                    ForEach(0...5, id: \.self) { userId in
                        HStack {
                            let user = User(id: userId.formatted(), name: mockedNames[userId], email: "", photoURL: nil)
                            PersonCardView(user: user)

                            Spacer()

                            Button {

                            } label: {
                                Text("Invite")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
        }
        .navigationTitle("Add Connection")
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            //billsModel.searchUser(using: newValue)
        }
        .onSubmit {
            //billsModel.searchUser(using: newValue)
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
