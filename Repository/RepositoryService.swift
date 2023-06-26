//
//  RepositoryService.swift
//  Bills
//
//  Created by Alex Zaharia on 25.01.2023.
//

import Foundation
import FirebaseFirestore

struct RepositoryService {

    /// An instance of a Firestore reference.
    private static let databaseRef = Firestore.firestore()

    /// Performs a request based on a reference of Firestore database.
    static func performRequest<T: RepositoryResponse>(_ request: ((Firestore) async throws -> T)) async throws -> T {
        do {
            return try await request(databaseRef)
        } catch {
            throw RepositoryServiceError(error)
        }
    }
}
