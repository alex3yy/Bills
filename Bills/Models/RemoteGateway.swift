//
//  RemoteGateway.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation

extension Gateway where Self == RemoteGateway {

    /// A gateway that provides API calls from the remote repository.
    static var remote: RemoteGateway {
        RemoteGateway()
    }
}

struct RemoteGateway: Gateway {

    // MARK: - Auth user methods

    func getUser(id: User.ID) async throws -> User {
        var request = GetUserRequest()
        request.id = id

        let response = try await request.response()

        return User(response.user)
    }

    func addUser(id: User.ID, name: String, email: String, photoURL: String?) async throws -> User {
        var request = AddUserRequest()
        request.id = id
        request.name = name
        request.email = email
        //request.photoURL = photoURL

        let response = try await request.response()

        return User(response.user)
    }

    func updateUser(id: User.ID, name: String?, email: String?, photoData: Data?) async throws -> User {
        var request = UpdateUserRequest()
        request.id = id
        request.name = name
        request.email = email
        //request.photoData = photoData

        let response = try await request.response()

        return User(response.user)
    }

    func deleteUser(id: User.ID) async throws {
        var request = DeleteUserRequest()
        request.id = id

        _ = try await request.response()
    }

    // MARK: - Search user methods

    func searchUser(id: User.ID) async throws -> User? {
        var request = SearchUserRequest()
        request.id = id

        let response = try await request.response()

        return User(response.user)
    }

    // MARK: - Invite user methods

    func inviteUser(senderId: User.ID, receiverId: User.ID) async throws {
        var request = InviteUserRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        _ = try await request.response()
    }

    func invitedUser(senderId: User.ID, receiverId: User.ID) async throws -> Bool {
        var request = CheckInvitedUserRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId
        
        let response = try await request.response()

        return response.isInvited
    }

    func getUserInvitations(userId: User.ID) async throws -> AsyncStream<[Invitation]> {
        var request = GetUserInvitationsRequest()
        request.userId = userId

        let response = try await request.response()

        let invitationsStream = AsyncStream {
            for await invitationDtos in response.invitationsStream {
                return invitationDtos.map(Invitation.init)
            }
            return []
        }

        return invitationsStream
    }

    func deleteUserInvitation(senderId: User.ID, receiverId: User.ID) async throws {
        var request = DeleteUserInvitationRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        _ = try await request.response()
    }

    // MARK: - Connection user methods
    func addUserConnection(senderId: User.ID, receiverId: User.ID) async throws {
        var request = AddUserConnectionRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        _ = try await request.response()
    }
}
