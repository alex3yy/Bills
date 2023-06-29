//
//  Bill.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import Foundation

extension Bill {
    enum Provider: String, Identifiable, CaseIterable {
        var id: Self { self }

        case digi
        case orange
        case eon
        case electrica
        case vodafone
    }

    struct Service: Identifiable {
        var id: String = UUID().uuidString
        var title: String = ""
        var price: Double = 0
        var currencyCode: String = "RON"
    }

    struct Client {
        var id: String = ""
        var name: String = ""
    }
}

struct Bill: Identifiable {
    var id: String = ""
    var client: Client = Client()
    var provider: Provider = .digi
    var services: [Service] = []
    var currencyCode: String = "RON"

    var price: Double {
        services.map(\.price).reduce(0, +)
    }

    mutating func addNewService() {
        services.append(Service())
    }

    mutating func generateRandomBill() {
        services = []
        provider = Provider.allCases.randomElement()!

        var shuffled = Bill.Service.mockedServices.shuffled()
        for _ in 0..<Int.random(in: 1...4) {
            let element = shuffled.popLast()!
            services.append(element)
        }
    }
}

extension Bill.Service {
    static var mockedServices: [Self] = [
        .init(title: "Serv. telecomunicatii", price: Double.random(in: 20...500), currencyCode: "RON"),
        .init(title: "TV", price: Double.random(in: 20...500), currencyCode: "RON"),
        .init(title: "Internet", price: Double.random(in: 20...500), currencyCode: "RON"),
        .init(title: "Consum energie", price: Double.random(in: 20...500), currencyCode: "RON"),
        .init(title: "Gaze naturale", price: Double.random(in: 20...500), currencyCode: "RON"),
        .init(title: "Verificare tehnica", price: Double.random(in: 20...500), currencyCode: "RON"),
        .init(title: "Echipament", price: Double.random(in: 20...500), currencyCode: "RON"),
    ]
}
