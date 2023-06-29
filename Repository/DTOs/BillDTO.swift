//
//  BillDTO.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import Foundation

extension BillDTO {
    struct ServiceDTO: Codable {
        var title: String
        var price: Double
        var currencyCode: String
    }

    struct ClientDTO: Codable {
        var uid: String
        var name: String
    }
}

struct BillDTO: Codable {
    var uid: String
    var client: ClientDTO
    var provider: String
    var services: [ServiceDTO]
    var price: Double
    var currencyCode: String
}
