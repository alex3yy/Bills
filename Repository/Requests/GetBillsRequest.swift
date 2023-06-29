//
//  GetBillsRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct GetBillsResponse: RepositoryResponse {
    var bills: [BillDTO]
}

struct GetBillsRequest: RepositoryRequest {

    var userId: String = ""

    func response() async throws -> GetBillsResponse {
        try await RepositoryService.performRequest { databaseRef in
            let billsDocumentsRef = databaseRef
                .collection("bills")
                .whereField("client.uid", isEqualTo: userId)

            let billsDocuments = try await billsDocumentsRef.getDocuments()
            let bills = try billsDocuments.documents.map { snapshot in
                let bill = try snapshot.data(as: BillDTO.self)
                return bill
            }

            return GetBillsResponse(bills: bills)
        }
    }
}
