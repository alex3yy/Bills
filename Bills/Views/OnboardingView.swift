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
            Text("Welcome to Bills!")
                .font(.title)
            Text("Manage your domains and bills from one place")
                .font(.title3)
                .multilineTextAlignment(.center)
                .bold()
            Text("Track your due bills, check bills history, share bills with your tenants and many more!")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 24)
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
