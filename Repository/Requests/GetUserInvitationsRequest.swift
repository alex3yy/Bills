//
//  GetUserInvitationsRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct GetUserInvitationsResponse: RepositoryResponse {
    var invitations: [InvitationDTO]
}

struct GetUserInvitationsRequest: RepositoryRequest {

    var userId: String = ""

    func response() async throws -> GetUserInvitationsResponse {
        try await RepositoryService.performRequest { databaseRef in
            let invitationsDocumentRef = databaseRef.collection("users")
                .document(userId)
                .collection("invitations")

            let invitationsDocuments = try await invitationsDocumentRef.getDocuments()

            let invitations = try invitationsDocuments.documents.map { snapshot in
                try snapshot.data(as: InvitationDTO.self)
            }

            return GetUserInvitationsResponse(invitations: invitations)
        }
    }
}
