//
//  GetSharedBillsRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 30.06.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct GetSharedBillsResponse: RepositoryResponse {
    var bills: [BillDTO]
}

struct GetSharedBillsRequest: RepositoryRequest {

    var userId: String = ""

    func response() async throws -> GetSharedBillsResponse {
        try await RepositoryService.performRequest { databaseRef in
            let billsDocumentsRef = databaseRef
                .collection("bills")
                .whereField("viewersUids", arrayContains: userId)

            let billsDocuments = try await billsDocumentsRef.getDocuments()
            let bills = try billsDocuments.documents.map { snapshot in
                let bill = try snapshot.data(as: BillDTO.self)
                return bill
            }

            return GetSharedBillsResponse(bills: bills)
        }
    }
}
