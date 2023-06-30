//
//  DeleteSharedBillsForUserRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 30.06.2023.
//

import Foundation
import FirebaseFirestore

struct DeleteSharedBillsForUserResponse: RepositoryResponse {

}

struct DeleteSharedBillsForUserRequest: RepositoryRequest {

    var userId: String = "" // landlordId
    //var tenantId: String = ""

    func response() async throws -> DeleteSharedBillsForUserResponse {
        try await RepositoryService.performRequest { databaseRef in
            let billsDocumentsRef = databaseRef
                .collection("bills")
                .whereField("viewersUids", arrayContains: userId)

            let billsDocuments = try await billsDocumentsRef.getDocuments()

            _ = try await databaseRef.runTransaction { transaction, error in
                for document in billsDocuments.documents {
                    let docReference = document.reference

                    do {
                        var bill = try document.data(as: BillDTO.self)
                        bill.viewersUids.removeAll(where: {$0 == userId})
                        transaction.updateData([
                            "isShared": !bill.viewersUids.isEmpty,
                            "viewersUids": bill.viewersUids
                        ], forDocument: docReference)
                    } catch {
                        print(error)
                        return nil
                    }
                }

                return nil
            }

            return DeleteSharedBillsForUserResponse()
        }
    }
}
