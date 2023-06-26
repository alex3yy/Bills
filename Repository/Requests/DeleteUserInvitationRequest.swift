//
//  DeleteUserInvitationRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct DeleteUserInvitationResponse: RepositoryResponse {

}

struct DeleteUserInvitationRequest: RepositoryRequest {

    var senderUserId: String = ""
    var receiverUserId: String = ""

    func response() async throws -> DeleteUserInvitationResponse {
        try await RepositoryService.performRequest { databaseRef in
            let senderInvitationDocumentRef = databaseRef.collection("users")
                .document(senderUserId)
                .collection("invitations")
                .document(receiverUserId)

            let receiverInvitationDocumentRef = databaseRef.collection("users")
                .document(receiverUserId)
                .collection("invitations")
                .document(senderUserId)

            // Get new write batch
            let batch = databaseRef.batch()
            batch.deleteDocument(senderInvitationDocumentRef)
            batch.deleteDocument(receiverInvitationDocumentRef)

            // Commit the batch
            try await batch.commit()

            return DeleteUserInvitationResponse()
        }
    }
}
