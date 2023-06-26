//
//  InvitationDTO.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation

struct InvitationDTO: Codable {
    enum Status: String, Codable {
        case SENT
        case RECEIVED
    }

    var uid: String
    var user: UserMetadataDTO
    var status: Status
}
