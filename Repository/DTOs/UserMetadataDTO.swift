//
//  UserMetadataDTO.swift
//  Bills
//
//  Created by Alex Zaharia on 23.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// An user's public details.
struct UserMetadataDTO: Codable {
    var uid: String = ""
    var name: String = ""
    @ExplicitNull var photoUrl: String? = nil

    var _createdAt: Timestamp = Timestamp()
    @ExplicitNull var _updatedAt: Timestamp? = nil
}
