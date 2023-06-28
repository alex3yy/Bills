//
//  AddUserConnectionRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 27.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct AddUserConnectionResponse: RepositoryResponse {

}

struct AddUserConnectionRequest: RepositoryRequest {

    var senderUserId: String = ""
    var receiverUserId: String = ""

    func response() async throws -> AddUserConnectionResponse {
        try await RepositoryService.performRequest { databaseRef in
            let senderConnectionsDocumentsRef = databaseRef.collection("users")
                .document(senderUserId)
                .collection("connections")
                .document(receiverUserId)

            let receiverConnectionsDocumentsRef = databaseRef.collection("users")
                .document(receiverUserId)
                .collection("connections")
                .document(senderUserId)

            let senderUserMetadataRequest = GetUserMetadataRequest(id: senderUserId)
            let senderUserMetadataResponse = try await senderUserMetadataRequest.response()

            let receiverUserMetadataRequest = GetUserMetadataRequest(id: receiverUserId)
            let receiverUserMetadataResponse = try await receiverUserMetadataRequest.response()

            let senderUserMetadataInfo = senderUserMetadataResponse.userMetadata
            let receiverUserMetadataInfo = receiverUserMetadataResponse.userMetadata

            let senderConnection = ConnectionDTO(
                user: senderUserMetadataInfo,
                role: .LANDLORD
            )

            let receiverConnection = ConnectionDTO(
                user: receiverUserMetadataInfo,
                role: .TENANT
            )

            try senderConnectionsDocumentsRef.setData(from: receiverConnection)
            try receiverConnectionsDocumentsRef.setData(from: senderConnection)

            return AddUserConnectionResponse()
        }
    }
}
