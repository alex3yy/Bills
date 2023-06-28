//
//  BillShareView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillShareView: View {
    @EnvironmentObject private var billsModel: BillsModel

    var bill: Bill

    @State private var searchText: String = ""
    @State private var isLoadingConnections: Bool = false

    var filteredConnections: [Connection] {
        guard !searchText.isEmpty else {
            return billsModel.connections
        }

        return billsModel.connections.filter { connection in
            connection.user.name.contains(searchText)
        }
    }

    var body: some View {
        Group {
            if filteredConnections.isEmpty {
                Text("You do not have any connections to share your bill with.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            } else {
                List {
                    ForEach(filteredConnections) { connection in
                        HStack {
                            PersonCardView(user: connection.user)

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
        .task {
            getUserConnections()
        }
//        .onChange(of: searchText) { newValue in
//            //billsModel.searchUser(using: newValue)
//        }
//        .onSubmit {
//            //billsModel.searchUser(using: newValue)
//        }
    }

    private func getUserConnections() {
        Task {
            do {
                isLoadingConnections = true
                try await billsModel.getUserConnections()
                isLoadingConnections = false
            } catch {
                isLoadingConnections = false
                print(error)
            }
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
