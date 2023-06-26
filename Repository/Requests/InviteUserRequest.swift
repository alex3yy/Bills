//
//  InviteUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation

struct InviteUserResponse: RepositoryResponse {

}

struct InviteUserRequest: RepositoryRequest {

    var senderUserId: String = ""
    var receiverUserId: String = ""

    func response() async throws -> InviteUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let senderInvitationDocumentRef = databaseRef.collection("users")
                .document(senderUserId)
                .collection("invitations")
                .document()

            let receiverInvitationDocumentRef = databaseRef.collection("users")
                .document(receiverUserId)
                .collection("invitations")
                .document()

            let senderUserMetadataRequest = GetUserMetadataRequest(id: senderUserId)
            let senderUserMetadataResponse = try await senderUserMetadataRequest.response()

            let receiverUserMetadataRequest = GetUserMetadataRequest(id: receiverUserId)
            let receiverUserMetadataResponse = try await receiverUserMetadataRequest.response()

            let senderUserMetadataInfo = senderUserMetadataResponse.userMetadata
            let receiverUserMetadataInfo = receiverUserMetadataResponse.userMetadata

            let senderInvitation = InvitationDTO(
                uid: senderInvitationDocumentRef.documentID,
                user: receiverUserMetadataInfo,
                status: .SENT
            )

            let receiverInvitation = InvitationDTO(
                uid: receiverInvitationDocumentRef.documentID,
                user: senderUserMetadataInfo,
                status: .RECEIVED
            )

            // Get new write batch
            let batch = databaseRef.batch()
            try batch.setData(from: senderInvitation, forDocument: senderInvitationDocumentRef)
            try batch.setData(from: receiverInvitation, forDocument: receiverInvitationDocumentRef)

            // Commit the batch
            try await batch.commit()

            return InviteUserResponse()
        }
    }
}
