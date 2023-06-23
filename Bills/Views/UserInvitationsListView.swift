//
//  UserInvitationsListView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct UserInvitationsListView: View {
    @EnvironmentObject private var billsModel: BillsModel

    let mockedNames = [
        "Alex Zaharia",
        "Cristiana Chiuzan"
    ]

    var body: some View {
        if billsModel.activeInvitationsCount == 0 {
            Text("There are no invitations yet.")
                .foregroundColor(.secondary)
        } else {
            List {
                ForEach(0...billsModel.activeInvitationsCount-1, id: \.self) { userId in
                    UserInvitationView(user: User(id: userId.formatted(), name: mockedNames[userId]))
                }
            }
        }
    }
}

struct UserInvitationsListView_Previews: PreviewProvider {
    static var previews: some View {
        UserInvitationsListView()
            .environmentObject(BillsModel(gateway: .remote))
    }
}
