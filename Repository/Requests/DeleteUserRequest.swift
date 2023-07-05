//
//  DeleteUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 27.01.2023.
//

import Foundation
import FirebaseFirestore

struct DeleteUserResponse: RepositoryResponse {

}

struct DeleteUserRequest: RepositoryRequest {

    var id: String = ""

    func response() async throws -> DeleteUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let userDocumentRef = databaseRef.collection("users").document(id)
            let userConnectionsDocumentRef = databaseRef.collection("users")
                .document(id)
                .collection("connections")
            let connectionsDocumentsRef = databaseRef.collectionGroup("connections")
                .whereField("user.uid", isEqualTo: id)
            let billsDocumentRef = databaseRef.collection("bills")
                .whereField("client.uid", isEqualTo: id)

            let userConnectionsDocuments = try await userConnectionsDocumentRef.getDocuments()
            let connectionsDocuments = try await connectionsDocumentsRef.getDocuments()
            let billsDocuments = try await billsDocumentRef.getDocuments()

            let batch = databaseRef.batch()

            for document in userConnectionsDocuments.documents {
                let documentRef = document.reference
                batch.deleteDocument(documentRef)
            }

            batch.deleteDocument(userDocumentRef)

            for document in connectionsDocuments.documents {
                let documentRef = document.reference
                batch.deleteDocument(documentRef)
            }

            for document in billsDocuments.documents {
                let documentRef = document.reference
                batch.deleteDocument(documentRef)
            }

            try await batch.commit()

            let deleteSharedBillsRequest = DeleteSharedBillsForUserRequest(userId: id)
            _ = try await deleteSharedBillsRequest.response()

            return DeleteUserResponse()
        }
    }
}
