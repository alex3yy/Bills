//
//  UserInvitationView.swift
//  Bills
//
//  Created by Alex Zaharia on 21.06.2023.
//

import SwiftUI

struct UserInvitationView: View {

    var invitation: Invitation

    var body: some View {
        switch invitation.status {
        case .received:
            ReceivedInvitationCardView(user: invitation.user)
        case .sent:
            SentInvitationCardView(user: invitation.user)
        }
    }
}

private struct SentInvitationCardView: View {
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

                Text("You invited this person to join your domain.")
                    .font(.subheadline)
            }

            Spacer()

            Button(role: .destructive) {

            } label: {
                Label("Remove", systemImage: "trash")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.white)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

private struct ReceivedInvitationCardView: View {
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
        Group {
            UserInvitationView(invitation: Invitation(
                id: "1",
                user: User(id: "1", name: "John Appleseed"),
                status: .received)
            )

            UserInvitationView(invitation: Invitation(
                id: "1",
                user: User(id: "1", name: "John Appleseed"),
                status: .sent)
            )
        }
        .padding()
    }
}
