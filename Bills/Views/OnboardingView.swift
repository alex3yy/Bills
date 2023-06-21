//
//  OnboardingView.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import SwiftUI

struct OnboardingView: View {

    @State private var isPresentingAuthPage: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Bills")
                .font(.title)
            Text("📖")
                .font(.title)
            Text("Welcome!")
                .font(.title3)
                .bold()
            Text("Track your due bills, bills history, upload bills and many more!")
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .safeAreaInset(edge: .bottom) {
            Button {
                isPresentingAuthPage = true
            } label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.roundedProminent)
            .padding()
        }
        .sheet(isPresented: $isPresentingAuthPage) {
            AuthView()
                .ignoresSafeArea()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(BillsModel(gateway: .remote))
    }
}
