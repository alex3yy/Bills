//
//  Gateway.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation

protocol Gateway {
    // MARK: - Auth user methods
    func getUser(id: User.ID) async throws -> User
    func addUser(id: User.ID, name: String, email: String, photoURL: String?) async throws -> User
    func updateUser(id: User.ID, name: String?, email: String?, photoData: Data?) async throws -> User
    func deleteUser(id: User.ID) async throws

    // MARK: - Search user methods
    func searchUser(id: User.ID) async throws -> User?

    // MARK: - Invite user methods
    func inviteUser(senderId: User.ID, receiverId: User.ID) async throws
    func invitedUser(senderId: User.ID, receiverId: User.ID) async throws -> Invitation.Status?
    func getUserInvitations(userId: User.ID) async throws -> AsyncStream<[Invitation]>
    func deleteUserInvitation(senderId: User.ID, receiverId: User.ID) async throws

    // MARK: - Connection user methods
    func addUserConnection(senderId: User.ID, receiverId: User.ID) async throws
    func connectedUser(senderId: User.ID, receiverId: User.ID) async throws -> Bool
    func getUserConnections(userId: User.ID) async throws -> [Connection]
    func deleteUserConnection(senderId: User.ID, receiverId: User.ID) async throws

    // MARK: - Bills methods
    func addBill(userId: User.ID, bill: Bill) async throws
    func getBills(userId: User.ID) async throws -> [Bill]
    func addSharedBill(viewerId: User.ID, billId: Bill.ID) async throws
}
