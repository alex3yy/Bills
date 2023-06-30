//
//  UpdateSharedBillRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UpdateSharedBillResponse: RepositoryResponse {

}

struct UpdateSharedBillRequest: RepositoryRequest {

    var viewerIds: [String] = []
    var billId: String = ""

    func response() async throws -> UpdateSharedBillResponse {
        try await RepositoryService.performRequest { databaseRef in
            let billsDocumentsRef = databaseRef
                .collection("bills")
                .document(billId)

            billsDocumentsRef.updateData(["viewersUids": viewerIds])

            return UpdateSharedBillResponse()
        }
    }
}
