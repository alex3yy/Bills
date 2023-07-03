//
//  DeleteUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 27.01.2023.
//

import Foundation

struct DeleteUserResponse: RepositoryResponse {

}

struct DeleteUserRequest: RepositoryRequest {

    var id: String = ""

    func response() async throws -> DeleteUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let userDocumentRef = databaseRef.collection("users").document(id)
            let connectionsDocumentsRef = databaseRef.collectionGroup("connections")
                .whereField("user.uid", isEqualTo: id)
            let billsDocumentRef = databaseRef.collection("bills")
                .whereField("client.uid", isEqualTo: id)
            let sharedBillsDocumentRef = databaseRef.collection("bills")
                .whereField("viewersUids", arrayContains: id)

            let connectionsDocuments = try await connectionsDocumentsRef.getDocuments()
            let billsDocuments = try await billsDocumentRef.getDocuments()
            let sharedBillsDocuments = try await sharedBillsDocumentRef.getDocuments()

            let batch = databaseRef.batch()

            batch.deleteDocument(userDocumentRef)

            for document in connectionsDocuments.documents {
                let documentRef = document.reference
                batch.deleteDocument(documentRef)
            }

            for document in billsDocuments.documents {
                let documentRef = document.reference
                batch.deleteDocument(documentRef)
            }

            for document in sharedBillsDocuments.documents {
                let documentRef = document.reference
                batch.deleteDocument(documentRef)
            }

            try await batch.commit()

            return DeleteUserResponse()
        }
    }
}
