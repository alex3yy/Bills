//
//  NavigationModel.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation

final class NavigationModel: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var isPresentingAddConnectionsView: Bool = false
    
    func reset() {
        selectedTab = .home
        isPresentingAddConnectionsView = false
    }

    func presentAddConnectionsView() {
        isPresentingAddConnectionsView = true
    }

    func dismissAddConnectionsView() {
        isPresentingAddConnectionsView = false
    }
}
