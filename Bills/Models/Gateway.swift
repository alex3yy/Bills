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
}
