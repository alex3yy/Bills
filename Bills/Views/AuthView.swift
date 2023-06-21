//
//  AuthView.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import SwiftUI
import Firebase
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI
//import FirebaseOAuthUI

struct AuthView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.parent = self
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        context.coordinator.makeAuthViewController()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, FUIAuthDelegate {
        var parent: AuthView
        var authUI: FUIAuth = FUIAuth.defaultAuthUI()!

        init(parent: AuthView) {
            self.parent = parent
            super.init()
        }

        func makeAuthViewController() -> UINavigationController {
            authUI.delegate = self
            authUI.providers = makeIDProviders()

            let controller = authUI.authViewController()
            return controller
        }

        private func makeIDProviders() -> [FUIAuthProvider] {
            var providers = [FUIAuthProvider]()

            // Email based credentials
            providers.append(FUIEmailAuth())

            // Google ID
            providers.append(FUIGoogleAuth(authUI: authUI))

            // Apple ID
            //providers.append(FUIOAuth.appleAuthProvider())

            // Facebook ID
            //providers.append(FUIFacebookAuth(authUI: authUI))

            return providers
        }

        // MARK: - FUIAuthDelegate

        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            switch error {
            case .some(let error as NSError) where UInt(error.code) == FUIAuthErrorCode.userCancelledSignIn.rawValue:
                print("User cancelled sign-in")
            case .some(let error as NSError) where error.userInfo[NSUnderlyingErrorKey] != nil:
                print("Login error: \(error.userInfo[NSUnderlyingErrorKey]!)")
            case .some(let error):
                print("Login error: \(error.localizedDescription)")
            case .none:
                return
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
