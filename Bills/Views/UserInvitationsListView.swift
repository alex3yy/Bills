//
//  UserInvitationsListView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct UserInvitationsListView: View {
    @EnvironmentObject private var billsModel: BillsModel

    var body: some View {

        if billsModel.activeInvitationsCount == 0 {
            Text("There are no invitations yet.")
                .foregroundColor(.secondary)
        } else {
            List {
                ForEach(0...5, id: \.self) { _ in
                    UserInvitationView()
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
