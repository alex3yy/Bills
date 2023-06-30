//
//  AddBillRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct AddBillResponse: RepositoryResponse {

}

struct AddBillRequest: RepositoryRequest {

    var userId: String
    var billDto: BillDTO

    func response() async throws -> AddBillResponse {
        try await RepositoryService.performRequest { databaseRef in
            let billsDocumentsRef = databaseRef
                .collection("bills")
                .document()

            let bill = BillDTO(
                uid: billsDocumentsRef.documentID,
                client: billDto.client,
                provider: billDto.provider,
                services: billDto.services,
                price: billDto.price,
                currencyCode: billDto.currencyCode,
                dueDate: billDto.dueDate,
                paymentStatus: billDto.paymentStatus
            )

            try billsDocumentsRef.setData(from: bill)

            return AddBillResponse()
        }
    }
}
