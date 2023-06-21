//
//  NavigationModel.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation

final class NavigationModel: ObservableObject {
    @Published var selectedTab: Tab = .home

    func reset() {
        selectedTab = .home
    }
}
