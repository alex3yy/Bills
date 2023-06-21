//
//  RepositoryRequest.swift
//  Bills
//
//  Created by Alex Zaharia on 25.01.2023.
//

import Foundation

protocol RepositoryRequest {
    associatedtype Response: RepositoryResponse
    func response() async throws -> Response
}

protocol RepositoryResponse {}
