//
//  CheckInvitedUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct CheckInvitedUserResponse: RepositoryResponse {
    var isInvited: Bool
}

struct CheckInvitedUserRequest: RepositoryRequest {

    var senderUserId: String = ""
    var receiverUserId: String = ""

    func response() async throws -> CheckInvitedUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let userInvitationQueryRef = databaseRef.collection("users")
                .document(receiverUserId)
                .collection("invitations")
                .whereField("user.uid", isEqualTo: senderUserId)

            let userInvitationsCountQuery = userInvitationQueryRef.count
            let userInvitationsCountQueryResult = try await userInvitationsCountQuery
                .getAggregation(source: .server)

            let userInvitationsCount = userInvitationsCountQueryResult.count
            let isUserInvited = userInvitationsCount != 0

            return CheckInvitedUserResponse(isInvited: isUserInvited)
        }
    }
}
