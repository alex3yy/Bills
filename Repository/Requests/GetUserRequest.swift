//
//  GetUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 27.01.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct GetUserResponse: RepositoryResponse {
    var user: UserDTO
}

struct GetUserRequest: RepositoryRequest {

    var id: String = ""

    func response() async throws -> GetUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            do {
                let documentRef = databaseRef.collection("users").document(id)
                let userRef = try await documentRef.getDocument()
                let user = try userRef.data(as: UserDTO.self)
                return GetUserResponse(user: user)
            } catch {
                throw RepositoryServiceError(error)
            }
        }
    }
}
