//
//  GetUserInvitationsRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct GetUserInvitationsResponse: RepositoryResponse {
    var invitationsStream: AsyncStream<[InvitationDTO]>
}

struct GetUserInvitationsRequest: RepositoryRequest {

    var userId: String = ""

    func response() async throws -> GetUserInvitationsResponse {
        try await RepositoryService.performRequest { databaseRef in
            let invitationsDocumentRef = databaseRef.collection("users")
                .document(userId)
                .collection("invitations")

            let asyncStream = AsyncStream<[InvitationDTO]> { continuation in
                invitationsDocumentRef.addSnapshotListener { snapshot, error in
                    guard let documents = snapshot?.documents,
                          !documents.isEmpty
                    else {
                        continuation.yield([])
                        return
                    }

                    do {
                        let invitations = try documents.map { snapshot in
                            let invitation = try snapshot.data(as: InvitationDTO.self)
                            return invitation
                        }
                        continuation.yield(invitations)
                    } catch {
                        print(error)
                        continuation.yield([])
                    }
                }
            }
            return GetUserInvitationsResponse(invitationsStream: asyncStream)
        }
    }
}
