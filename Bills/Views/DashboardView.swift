//
//  DashboardView.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//


import SwiftUI

enum Tab {
//    case home
    case bills
    case connections
    case account
}

struct DashboardView: View {

    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    var body: some View {
        TabView(selection: $navigationModel.selectedTab) {
//            Text("Home")
//                .tabItem {
//                    Label("My List", systemImage: "house.fill")
//                }
//                .tag(Tab.home)
            BillsView()
                .tabItem {
                    Label("Bills", systemImage: "doc.text.fill")
                }
                .tag(Tab.bills)
            ConnectionsView()
                .tabItem {
                    Label("Connections", systemImage: "person.3.fill")
                }
                .tag(Tab.connections)
                .badge(billsModel.activeInvitationsCount)
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                }
                .tag(Tab.account)
        }
        .task {
            try? await billsModel.getUserInvitations()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
