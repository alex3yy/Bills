//
//  RepositoryServiceError.swift
//  Bills
//
//  Created by Alex Zaharia on 25.01.2023.
//

import Foundation

public struct RepositoryServiceError: Error, LocalizedError {

    /// Checks whether two errors are equal, comparing their code.
    public static func == (lhs: RepositoryServiceError, rhs: RepositoryServiceError) -> Bool {
        lhs.code == rhs.code
    }

    public static func != (lhs: RepositoryServiceError, rhs: RepositoryServiceError) -> Bool {
        lhs.code != rhs.code
    }

    /// The error’s domain.
    public static var errorDomain: String {
        return "RepositoryServiceErrorDomain"
    }

    /// The domain of request errors.
    public let repositoryServiceErrorDomain: String = Self.errorDomain

    public enum Code: Int {

        case unknown

        case invalidArgument

        case unauthenticated

        case decodingFailed

        case encodingFailed
    }

    /// The error code.
    public var code: Code

    /// Supplemental data that might be included in a request error.
    public var errorUserInfo: [String: Any] = [:]

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        guard let errorDomain = errorUserInfo["domain"] as? String else { return "Cannot cast error domain" }
        guard let errorReason = errorUserInfo["reason"] as? String else { return "Cannot cast error reason message" }

        return "[\(errorDomain)] Code (\(code.rawValue)): \(code) - \(errorReason)"
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        errorUserInfo["reason"] as? String
    }

    internal init(code: Code, errorUserInfo: [String: Any] = [:]) {
        self.code = code
        self.errorUserInfo = errorUserInfo
        self.errorUserInfo["domain"] = Self.errorDomain
    }

    internal init(code: Code, reason: String) {
        self.code = code
        self.errorUserInfo["reason"] = reason
        self.errorUserInfo["domain"] = Self.errorDomain
    }
}

extension RepositoryServiceError {
    internal init(_ error: Error) {
        switch error {
        case let error as DecodingError:
            self.init(error)
        default:
            self.init(code: .unknown, errorUserInfo: [
                "underlyingError" : error
            ])
        }
    }

    fileprivate init(_ error: DecodingError) {
        self.init(code: .decodingFailed, errorUserInfo: [
            "reason" : "Failed to decode data from remote source. Error description: \(error.localizedDescription)"
        ])
    }

    fileprivate init(_ error: EncodingError) {
        self.init(code: .encodingFailed, errorUserInfo: [
            "reason" : "Failed to encode data from local source. Error description: \(error.localizedDescription)"
        ])
    }
}
