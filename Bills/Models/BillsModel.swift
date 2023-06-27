//
//  BillsModel.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation
import FirebaseAuth
import SwiftUI

extension BillsModel {
    enum AuthState {
        case unknown
        case signedIn
        case signedOut
        case error(Error)
    }
}

@MainActor
final class BillsModel: ObservableObject {

    /// A gateway responsible for the repository service calls.
    private let gateway: Gateway

    init(gateway: Gateway) {
        self.gateway = gateway

        registerAuthStateObserver()
    }

    // MARK: - Auth variables

    /// Value representing the current auth state.
    @Published private(set) var authState: AuthState = .unknown

    /// Value representing the current user.
    @Published var user: User?

    /// Token referencing the closure registered as auth state change handler.
    private var authStateChangeObserver: AuthStateDidChangeListenerHandle?

    /// A boolean indicating that the user details were stored on a remote repository.
    private var isUserStored: Bool = false

    // MARK: - Search Variables

    /// Value representing the searched user.
    @Published var searchedUser: User?

    // MARK: - Invitations Variables

    @Published private(set) var invitations: [Invitation] = []

    var activeInvitationsCount: Int {
        2
    }
    
    /// Signs out the current user.
    @MainActor
    func signOut() {
        try? Auth.auth().signOut()
    }

    private func removeAuthStateObserverIfNeeded() {
        if let observer = authStateChangeObserver {
            Auth.auth().removeStateDidChangeListener(observer)
            authStateChangeObserver = nil
        }
    }

    private func registerAuthStateObserver() {
        if authStateChangeObserver == nil {
            authStateChangeObserver = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                guard let self = self else { return }

                Task { @MainActor in
                    self.authState = .unknown
                    do {
                        if let currentUser = user {
                            // Initialize the current user.
                            self.user = User(currentUser)

                            if currentUser.displayName == nil {
                                // Wait a certain amount of time, until all the details are fetched.
                                try await Task.sleep(nanoseconds: 1_500_000_000)
                                self.user = User(currentUser)
                            }

                            await self.checkSignedUpUser()
                        } else {
                            self.clearUserSession()
                        }
                    } catch {
                        self.authState = .error(error)
                        print(error)
                    }
                }
            }
        }
    }

    @MainActor
    func checkSignedUpUser() async {
        do {
            if let user = self.user {
                // Add the user to the remote repository if needed.
                try await addUserIfNeeded(user)
                authState = .signedIn
            }
        } catch {
            authState = .error(error)
        }
    }

    /// Resets any saved states to the defaults.
    @MainActor
    func clearUserSession() {
        user = nil
        isUserStored = false
        authState = .signedOut
    }

    @MainActor
    func addUserIfNeeded(_ user: User) async throws {
        if !isUserStored {
            let responseUser = try await gateway.addUser(
                id: user.id,
                name: user.name,
                email: user.email,
                photoURL: nil //user.photoURL?.absoluteString
            )

            self.user = responseUser
        }
        isUserStored = true
    }

    @MainActor
    func getUser() async throws {
        guard let user = user else { return }

        // Fetch the user details from repository service.
        let storedUser = try await gateway.getUser(id: user.id)

        // Replace the details.
        self.user = storedUser
    }

    @MainActor
    func updateUser(_ data: User) async throws {

        // Update user details from repository service.
        let updatedUser = try await gateway.updateUser(
            id: data.id,
            name: data.name,
            email: data.email,
            photoData: nil
        )

        // Update user details.
        self.user = updatedUser
    }

    @MainActor
    func deleteUser(_ userID: String) async throws {
        // Mark user as deleted.
        _ = try await gateway.deleteUser(id: userID)
    }

    @MainActor
    func searchUser(for id: User.ID) async throws {
        searchedUser = nil
        
        guard let user,
              user.id != id,
              !id.isEmpty,
              id.allSatisfy({ $0.isLetter || $0.isWholeNumber })
        else {
            return
        }

        let foundUser = try await gateway.searchUser(id: id)
        self.searchedUser = foundUser
    }

    @MainActor
    func inviteUser(with id: User.ID) async throws {
        guard let user else { return }

        try await gateway.inviteUser(senderId: user.id, receiverId: id)
    }

    @MainActor
    func invitedUser(for id: User.ID) async throws -> Bool {
        guard let user else { fatalError("No current user.") }

        return try await gateway.invitedUser(senderId: user.id, receiverId: id)
    }

    @MainActor
    func getUserInvitations(completion: (Bool) -> Void = {_ in }) async throws {
        guard let user else { fatalError("No current user.") }

        invitations = []

        completion(false)
        let stream = try await gateway.getUserInvitations(userId: user.id)
        for await invitation in stream {
            invitations = invitation
            completion(true)
        }
    }

    @MainActor
    func deleteUserInvitation(for id: User.ID) async throws {
        guard let user else { fatalError("No current user.") }

        try await gateway.deleteUserInvitation(senderId: user.id, receiverId: id)
    }
}
