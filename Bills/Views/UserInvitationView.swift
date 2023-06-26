//
//  UserInvitationView.swift
//  Bills
//
//  Created by Alex Zaharia on 21.06.2023.
//

import SwiftUI

struct UserInvitationView: View {

    var invitation: Invitation
    var acceptAction: () -> Void = {}
    var deleteAction: () async throws -> Void = {}

    var body: some View {
        switch invitation.status {
        case .received:
            ReceivedInvitationCardView(user: invitation.user, acceptAction: acceptAction, deleteAction: deleteAction)
        case .sent:
            SentInvitationCardView(user: invitation.user, deleteAction: deleteAction)
        }
    }
}

private struct SentInvitationCardView: View {
    var user: User
    var deleteAction: () async throws -> Void

    @State private var isDeletingInvitation: Bool = false

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
                Task {
                    do {
                        isDeletingInvitation = true
                        try await deleteAction()
                        isDeletingInvitation = false
                    } catch {
                        isDeletingInvitation = false
                        print(error)
                    }
                }
            } label: {
                Label("Remove", systemImage: "trash")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.white)
                    .opacity(isDeletingInvitation ? 0 : 1)
                    .overlay {
                        if isDeletingInvitation {
                            ProgressView()
                        }
                    }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isDeletingInvitation)
        }
    }
}

private struct ReceivedInvitationCardView: View {
    var user: User
    var acceptAction: () -> Void
    var deleteAction: () async throws -> Void

    @State private var isDeletingInvitation: Bool = false

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
                acceptAction()
            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.borderedProminent)

            Button(role: .destructive) {
                Task {
                    do {
                        isDeletingInvitation = true
                        try await deleteAction()
                        isDeletingInvitation = false
                    } catch {
                        isDeletingInvitation = false
                        print(error)
                    }
                }
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 20, height: 20)
                    .opacity(isDeletingInvitation ? 0 : 1)
                    .overlay {
                        if isDeletingInvitation {
                            ProgressView()
                        }
                    }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isDeletingInvitation)
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
