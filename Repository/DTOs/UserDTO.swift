//
//  UserDTO.swift
//  Bills
//
//  Created by Alex Zaharia on 27.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// An user's private details.
struct UserDTO: Codable {
    var uid: String = ""
    var name: String = ""
    var email: String = ""
    @ExplicitNull var photoUrl: String? = nil

    var _createdAt: Timestamp = Timestamp()
    @ExplicitNull var _updatedAt: Timestamp? = nil
}
