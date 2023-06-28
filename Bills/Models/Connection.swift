//
//  Connection.swift
//  Bills
//
//  Created by Alex Zaharia on 28.06.2023.
//

import Foundation

extension Connection {
    enum Role {
        case tenant
        case landlord
    }
}

struct Connection: Identifiable {
    var id: String {
        user.id
    }

    var user: User
    var role: Role

    var isTenant: Bool {
        role == .tenant
    }

    var isLandlord: Bool {
        role == .landlord
    }
}

extension Connection {
    init(_ connectionDto: ConnectionDTO) {
        self.role = Connection.Role(connectionDto.role)
        self.user = User(connectionDto.user)
    }
}

extension Connection.Role {
    init(_ roleDto: ConnectionDTO.Role) {
        switch roleDto {
        case .LANDLORD:
            self = .landlord
        case .TENANT:
            self = .tenant
        }
    }
}
