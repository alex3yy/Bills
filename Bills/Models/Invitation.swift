//
//  Invitation.swift
//  Bills
//
//  Created by Alex Zaharia on 26.06.2023.
//

import Foundation

struct Invitation: Identifiable {
    enum Status {
        case sent
        case received
    }

    var id: String
    var user: User
    var status: Status

    var isSent: Bool {
        status == .sent
    }

    var isReceived: Bool {
        status == .received
    }
}

extension Invitation {
    init(_ invitationDTO: InvitationDTO) {
        self.id = invitationDTO.uid
        self.user = User(invitationDTO.user)
        self.status = Invitation.Status(invitationDTO.status)
    }
}

extension Invitation.Status {
    init(_ invitationDTOStatus: InvitationDTO.Status) {
        switch invitationDTOStatus {
        case .SENT:
            self = .sent
        case .RECEIVED:
            self = .received
        }
    }
}
