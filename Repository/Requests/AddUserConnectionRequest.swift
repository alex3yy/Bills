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

            let senderConnection = ConnectionDTO(
                userUid: senderUserId,
                role: .LANDLORD
            )

            let receiverConnection = ConnectionDTO(
                userUid: receiverUserId,
                role: .TENANT
            )

            try senderConnectionsDocumentsRef.setData(from: receiverConnection)
            try receiverConnectionsDocumentsRef.setData(from: senderConnection)

            return AddUserConnectionResponse()
        }
    }
}
