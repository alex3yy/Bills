//
//  UpdateUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 27.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UpdateUserResponse: RepositoryResponse {
    let user: UserDTO
}

struct UpdateUserRequest: RepositoryRequest {

    var id: String = ""
    var name: String?
    var email: String?
    //var photoData: Data?

    func response() async throws -> UpdateUserResponse {
        try await RepositoryService.performRequest { databaseRef in

            let userDocumentRef = databaseRef.collection("users").document(id)

            //                var photoURL: String?
            //                if let photoData = photoData {
            //
            //                    // Upload the image to Firebase Storage.
            //                    var request = UploadImageRequest()
            //                    request.storagePath = "profile/\(id)_\(UUID().uuidString)_profile.jpg"
            //                    request.imageData = photoData
            //
            //                    let response = try await request.response()
            //                    photoURL = response.imageUrl
            //                }

            let userData: [AnyHashable : Any?] = [
                "name": name,
                "email": email,
                //"photoUrl": photoURL,
                "_updatedAt": Timestamp(date: .now)
            ]
            let modifiedUserData = userData.filter({ $0.value != nil }) as [AnyHashable : Any]

            // Get new write batch
            let batch = databaseRef.batch()
            batch.updateData(modifiedUserData, forDocument: userDocumentRef)

            // Commit the batch
            try await batch.commit()

            // Get updated user.
            let request = GetUserRequest(id: id)
            let response = try await request.response()
            let updatedUser = response.user

            return UpdateUserResponse(user: updatedUser)
        }
    }
}
