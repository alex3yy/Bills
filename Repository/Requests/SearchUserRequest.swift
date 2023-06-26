//
//  SearchUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 23.06.2023.
//

import Foundation

struct SearchUserResponse: RepositoryResponse {
    let user: UserMetadataDTO
}

struct SearchUserRequest: RepositoryRequest {

    var id: String = ""

    func response() async throws -> SearchUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let documentRef = databaseRef.collection("users").document(id)
            let userRef = try await documentRef.getDocument()
            let user = try userRef.data(as: UserMetadataDTO.self)
            return SearchUserResponse(user: user)
        }
    }
}
