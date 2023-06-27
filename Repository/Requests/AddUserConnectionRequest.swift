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

            let receiverConnectionsDocumentsRef = databaseRef.collection("users")
                .document(receiverUserId)
                .collection("connections")

            let senderConnection = ConnectionDTO(
                uid: senderUserId,
                userId: senderUserId,
                role: .LANDLORD
            )

            let receiverConnection = ConnectionDTO(
                uid: receiverUserId,
                userId: receiverUserId,
                role: .TENANT
            )

            try senderConnectionsDocumentsRef.addDocument(from: receiverConnection)
            try receiverConnectionsDocumentsRef.addDocument(from: senderConnection)

            return AddUserConnectionResponse()
        }
    }
}
