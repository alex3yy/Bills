//
//  PayBillRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 30.06.2023.
//

import Foundation

struct PayBillResponse: RepositoryResponse {

}

struct PayBillRequest: RepositoryRequest {

    var id: String = ""

    func response() async throws -> PayBillResponse {
        try await RepositoryService.performRequest { databaseRef in
            let billDocumentRef = databaseRef.collection("bills")
                .document(id)

            billDocumentRef.updateData(["paymentStatus": "paid"])

            return PayBillResponse()
        }
    }
}
