//
//  UserConnectionSearchView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct UserConnectionSearchView: View {
    //@EnvironmentObject private var billsModel: BillsModel
    //let userMetadata: UserMetadata

    @State private var searchText: String = ""

    var body: some View {
        Group {
            if searchText.isEmpty {
                Text("Search for a user in order to invite him to join your managed domain.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            } else {
                List {
                    ForEach(0...5, id: \.self) { _ in
                        HStack(alignment: .center) {
                            Image(systemName: "person")
                                .resizable()
                                .padding()
                                .frame(width: 70, height: 70)
                                .background(.gray.opacity(0.1))
                                .clipShape(Circle())

                            Text("John Appleseed")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)

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
