//
//  BillShareView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillShareView: View {
    //@EnvironmentObject private var billsModel: BillsModel

    var bill: Bill

    @State private var searchText: String = ""

    var body: some View {
        Group {
            if searchText.isEmpty { //billsModel.connections.isEmpty
                Text("You do not have any connections to share your bill with.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            } else {
                List {
                    ForEach(0...5, id: \.self) { userId in
                        HStack {
                            let user = User(id: userId.formatted(), name: "John Appleseed", email: "", photoURL: nil)
                            PersonCardView(user: user)

                            Spacer()

                            Button {

                            } label: {
                                Text("Share")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            //billsModel.searchUser(using: newValue)
        }
        .onSubmit {
            //billsModel.searchUser(using: newValue)
        }
    }
}

struct BillShareView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BillShareView(bill: Bill(id: "1"))
        }
    }
}
