//
//  BillsApp.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import SwiftUI
import Firebase

@main
struct BillsApp: App {
    @StateObject private var billsModel = BillsModel(gateway: .remote)
    @StateObject private var navigationModel = NavigationModel()

    init() {
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()

        // Reduce the amount of noise.
        FirebaseConfiguration.shared.setLoggerLevel(.min)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(billsModel)
                .environmentObject(navigationModel)
        }
    }
}
