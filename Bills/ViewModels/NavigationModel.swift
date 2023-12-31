//
//  NavigationModel.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation

final class NavigationModel: ObservableObject {
    @Published var selectedTab: Tab = .bills
    @Published var isPresentingAddBillView: Bool = false
    @Published var isPresentingAddConnectionsView: Bool = false
    @Published var isPresentingUserInvitationsListView: Bool = false
    @Published var selectedBillForSharing: Bill?
    
    func reset() {
        selectedTab = .bills
        isPresentingAddBillView = false
        isPresentingAddConnectionsView = false
        isPresentingUserInvitationsListView = false
        selectedBillForSharing = nil
    }

    func presentAddBillView() {
        isPresentingAddBillView = true
    }

    func dismissAddBillView() {
        isPresentingAddBillView = false
    }

    func presentAddConnectionsView() {
        isPresentingAddConnectionsView = true
    }

    func dismissAddConnectionsView() {
        isPresentingAddConnectionsView = false
    }

    func presentUserInvitationsListView() {
        isPresentingUserInvitationsListView = true
    }

    func dismissUserInvitationsListView() {
        isPresentingUserInvitationsListView = false
    }

    func presentConnectionsListView(for bill: Bill) {
        selectedBillForSharing = bill
    }

    func dismissConnectionsListView() {
        selectedBillForSharing = nil
    }
}
