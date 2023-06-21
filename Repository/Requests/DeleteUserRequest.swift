//
//  DeleteUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 27.01.2023.
//

import Foundation

struct DeleteUserResponse: RepositoryResponse {

}

struct DeleteUserRequest: RepositoryRequest {

    var id: String = ""

    func response() async throws -> DeleteUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let documentRef = databaseRef.collection("users").document(id)

            try await documentRef.delete()

            return DeleteUserResponse()
        }
    }
}
