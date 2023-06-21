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
}
