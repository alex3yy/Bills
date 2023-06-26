//
//  GetUserMetadataRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation

import Foundation
import FirebaseFirestoreSwift

struct GetUserMetadataResponse: RepositoryResponse {
    var userMetadata: UserMetadataDTO
}

struct GetUserMetadataRequest: RepositoryRequest {

    var id: String = ""

    func response() async throws -> GetUserMetadataResponse {
        try await RepositoryService.performRequest { databaseRef in
            let documentRef = databaseRef.collection("users").document(id)
            let userRef = try await documentRef.getDocument()
            let userMetadata = try userRef.data(as: UserMetadataDTO.self)
            return GetUserMetadataResponse(userMetadata: userMetadata)
        }
    }
}
