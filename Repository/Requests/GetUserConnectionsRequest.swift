//
//  GetUserConnectionsRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 28.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct GetUserConnectionsResponse: RepositoryResponse {
    var connections: [ConnectionDTO]
}

struct GetUserConnectionsRequest: RepositoryRequest {

    var userId: String = ""

    func response() async throws -> GetUserConnectionsResponse {
        try await RepositoryService.performRequest { databaseRef in
            let connectionsDocumentsRef = databaseRef.collection("users")
                .document(userId)
                .collection("connections")

            let connectionsDocuments = try await connectionsDocumentsRef.getDocuments()
            let connections = try connectionsDocuments.documents.map { snapshot in
                let connection = try snapshot.data(as: ConnectionDTO.self)
                return connection
            }

            return GetUserConnectionsResponse(connections: connections)
        }
    }
}
