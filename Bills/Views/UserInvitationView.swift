//
//  UserInvitationView.swift
//  Bills
//
//  Created by Alex Zaharia on 21.06.2023.
//

import SwiftUI

struct UserInvitationView: View {

    var user: User

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person")
                .resizable()
                .padding()
                .frame(width: 60, height: 60)
                .background(.gray.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.headline)

                Text("Wants to add you to his or her managed domain.")
                    .font(.subheadline)
            }

            Spacer()

            Button {

            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.borderedProminent)

            Button(role: .destructive) {

            } label: {
                Image(systemName: "xmark")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct UserInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInvitationView(user: User(id: "1", name: "John Appleseed"))
            .padding()
    }
}
