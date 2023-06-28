//
//  CheckConnectedUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 28.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct CheckConnectedUserResponse: RepositoryResponse {
    var isConnected: Bool
}

struct CheckConnectedUserRequest: RepositoryRequest {

    var senderUserId: String = ""
    var receiverUserId: String = ""

    func response() async throws -> CheckConnectedUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let userConnectionsQueryRef = databaseRef.collection("users")
                .document(receiverUserId)
                .collection("connections")
                .whereField("user.uid", isEqualTo: senderUserId)

            let userConnectionsCountQuery = userConnectionsQueryRef.count
            let userConnectionsCountQueryResult = try await userConnectionsCountQuery
                .getAggregation(source: .server)

            let userConnectionsCount = userConnectionsCountQueryResult.count
            let isUserConnected = userConnectionsCount != 0

            return CheckConnectedUserResponse(isConnected: isUserConnected)
        }
    }
}
