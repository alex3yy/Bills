//
//  ContentView.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    var body: some View {
        VStack {
            switch billsModel.authState {
            case .unknown:
                ProgressView()
            case .signedIn:
                DashboardView()
            case .signedOut:
                OnboardingView()
            case .error(_):
                LoadingErrorView()
            }
        }
        .onChange(of: billsModel.user) { newUser in
            if newUser == nil {
                navigationModel.reset()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
