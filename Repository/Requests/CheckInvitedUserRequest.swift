//
//  CheckInvitedUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct CheckInvitedUserResponse: RepositoryResponse {
    var invitationStatus: InvitationDTO.Status?
}

struct CheckInvitedUserRequest: RepositoryRequest {

    var senderUserId: String = ""
    var receiverUserId: String = ""

    func response() async throws -> CheckInvitedUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let userInvitationDocumentRef = databaseRef.collection("users")
                .document(senderUserId)
                .collection("invitations")
                .document(receiverUserId)

            let userInvitationDocument = try await userInvitationDocumentRef.getDocument()

            if !userInvitationDocument.exists {
                return CheckInvitedUserResponse(invitationStatus: nil)
            }

            let fieldValue = userInvitationDocument.get("status") as! String
            let invitationStatus = InvitationDTO.Status(rawValue: fieldValue)

            return CheckInvitedUserResponse(invitationStatus: invitationStatus)
        }
    }
}
