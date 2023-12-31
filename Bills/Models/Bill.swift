//
//  Bill.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import Foundation

extension Bill {
    enum Provider: String, Identifiable, CaseIterable, Equatable, Hashable {
        var id: Self { self }

        case digi
        case orange
        case eon
        case electrica
        case vodafone
        case unknown
    }

    struct Service: Identifiable, Equatable, Hashable {
        var id: String = UUID().uuidString
        var title: String = ""
        var price: Double = 0
        var currencyCode: String = "RON"

        mutating func roundPrice(fractionalDigits: Int = 2) {
            price = price.rounded(fractionDigits: fractionalDigits)
        }
    }

    struct Client: Equatable, Hashable {
        var id: String = ""
        var name: String = ""
    }

    enum PaymentStatus: String, Equatable, Hashable {
        case paid
        case unpaid
        case due
    }
}

struct Bill: Identifiable, Equatable, Hashable {
    var id: String = ""
    var client: Client = Client()
    var provider: Provider = .digi
    var services: [Service] = []
    var currencyCode: String = "RON"
    var viewersIds: [String] = []
    var isShared: Bool = false
    var dueDate: Date = .distantFuture
    var paymentStatus: PaymentStatus = .unpaid

    init(id: String = "", client: Bill.Client = Client(), provider: Bill.Provider = .digi, services: [Bill.Service] = [], currencyCode: String = "RON", viewersIds: [String] = [], isShared: Bool = false, paymentStatus: Bill.PaymentStatus = .unpaid) {
        self.id = id
        self.client = client
        self.provider = provider
        self.services = services
        self.currencyCode = currencyCode
        self.viewersIds = viewersIds
        self.isShared = isShared

        let dateAfter30Days = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        self.dueDate = dateAfter30Days

        self.paymentStatus = paymentStatus
        initializePaymentStatus()
    }

    var price: Double {
        services.map(\.price).reduce(0, +).rounded(fractionDigits: 2)
    }

    var viewersCount: Int {
        viewersIds.count
    }

    func isOwner(userId: User.ID) -> Bool {
        client.id == userId
    }

    var isPaid: Bool {
        paymentStatus == .paid
    }

    private mutating func initializePaymentStatus() {
        let todayDate = Date()
        if dueDate >= todayDate {
            paymentStatus = .due
        } else {
            paymentStatus = .unpaid
        }
    }

    mutating func pay() {
        paymentStatus = .paid
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

    mutating func roundPrices(fractionalDigits: Int = 2) {
        for index in services.startIndex..<services.endIndex {
            services[index].roundPrice(fractionalDigits: fractionalDigits)
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

extension Bill {
    init(_ billDto: BillDTO) {
        self.id = billDto.uid
        self.client = Bill.Client(billDto.client)
        self.provider = Provider(rawValue: billDto.provider) ?? .unknown
        self.services = billDto.services.map(Bill.Service.init)
        self.viewersIds = billDto.viewersUids
        self.isShared = billDto.isShared
        self.dueDate = billDto.dueDate
        self.paymentStatus = PaymentStatus(rawValue: billDto.paymentStatus) ?? .unpaid
    }
}

extension Bill.Client {
    init(_ clientDto: BillDTO.ClientDTO) {
        self.id = clientDto.uid
        self.name = clientDto.name
    }
}

extension Bill.Service {
    init(_ serviceDto: BillDTO.ServiceDTO) {
        self.title = serviceDto.title
        self.price = serviceDto.price
        self.currencyCode = serviceDto.currencyCode
    }
}
