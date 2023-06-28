//
//  DeleteUserConnectionRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 28.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct DeleteUserConnectionResponse: RepositoryResponse {

}

struct DeleteUserConnectionRequest: RepositoryRequest {

    var senderUserId: String = ""
    var receiverUserId: String = ""

    func response() async throws -> DeleteUserConnectionResponse {
        try await RepositoryService.performRequest { databaseRef in
            let senderConnectionDocumentRef = databaseRef.collection("users")
                .document(senderUserId)
                .collection("connections")
                .document(receiverUserId)

            let receiverConnectionDocumentRef = databaseRef.collection("users")
                .document(receiverUserId)
                .collection("connections")
                .document(senderUserId)

            // Get new write batch
            let batch = databaseRef.batch()
            batch.deleteDocument(senderConnectionDocumentRef)
            batch.deleteDocument(receiverConnectionDocumentRef)

            // Commit the batch
            try await batch.commit()

            return DeleteUserConnectionResponse()
        }
    }
}
