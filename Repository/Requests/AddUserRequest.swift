//
//  AddUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 27.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddUserResponse: RepositoryResponse {
    var user: UserDTO
}

struct AddUserRequest: RepositoryRequest {

    var id: String = ""
    var name: String = ""
    var email: String = ""
    var photoURL: String?

    func response() async throws -> AddUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let userDocumentRef = databaseRef.collection("users").document(id)

            let userRef = try await userDocumentRef.getDocument()

            // Make sure the document does not exist.
            if userRef.exists {
                let request = GetUserRequest(id: id)
                let response = try await request.response()

                let storedUser = response.user

                // Make sure the user's name exists.
                if storedUser.name.isEmpty && !name.isEmpty {
                    var request = UpdateUserRequest(id: id)
                    request.name = name
                    let response = try await request.response()
                    return AddUserResponse(user: response.user)
                }

                return AddUserResponse(user: response.user)
            }

            let user = UserDTO(
                uid: id,
                name: name,
                email: email,
                photoUrl: photoURL,
                _createdAt: Timestamp(date: .now),
                _updatedAt: nil)

            // Get new write batch
            let batch = databaseRef.batch()
            try batch.setData(from: user, forDocument: userDocumentRef)

            // Commit the batch
            try await batch.commit()

            return AddUserResponse(user: user)
        }
    }
}
