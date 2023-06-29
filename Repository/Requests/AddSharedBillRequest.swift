//
//  AddSharedBillRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddSharedBillResponse: RepositoryResponse {

}

struct AddSharedBillRequest: RepositoryRequest {

    var viewerIds: [String] = []
    var billId: String = ""

    func response() async throws -> AddSharedBillResponse {
        try await RepositoryService.performRequest { databaseRef in
            let billsDocumentsRef = databaseRef
                .collection("bills")
                .document(billId)

            billsDocumentsRef.updateData(["viewersUids": viewerIds])

            return AddSharedBillResponse()
        }
    }
}
