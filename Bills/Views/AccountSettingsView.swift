//
//  AccountSettingsView.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import SwiftUI
import FirebaseAuthUI

struct AccountSettingsView: UIViewControllerRepresentable {

    @EnvironmentObject private var billsModel: BillsModel

    func makeUIViewController(context: Context) -> UINavigationController {
        context.coordinator.makeAccountSettingsViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.parent = self
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, FUIAuthDelegate {
        var parent: AccountSettingsView
        var authUI: FUIAuth = FUIAuth.defaultAuthUI()!

        init(parent: AccountSettingsView) {
            self.parent = parent
            super.init()
        }

        func makeAccountSettingsViewController() -> UINavigationController {
            authUI.delegate = self
            let controller = FUIAccountSettingsViewController(authUI: authUI)
            controller.title = "Account Settings"
            return UINavigationController(rootViewController: controller)
        }

        // MARK: - FUIAuthDelegate

        func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
            Task { @MainActor in
                if let user = authUI.auth?.currentUser.map(User.init) {
                    switch operation {
                    case .updateName, .updateEmail:
                        try await parent.billsModel.updateUser(user)
                    case .deleteAccount:
                        try await parent.billsModel.deleteUser(user.id)
                    default:
                        break
                    }
                }
            }
        }
    }
}
