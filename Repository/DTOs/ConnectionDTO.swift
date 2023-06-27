//
//  ConnectionDTO.swift
//  Bills
//
//  Created by Alex Zaharia on 27.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct ConnectionDTO: Codable {
    enum Role: String, Codable {
        case LANDLORD
        case TENANT
    }

    @DocumentID var uid: String?
    var userId: String
    var role: Role
}
