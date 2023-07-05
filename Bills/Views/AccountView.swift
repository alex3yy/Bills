//
//  AccountView.swift
//  Bills
//
//  Created by Alex Zaharia on 28.05.2023.
//

import SwiftUI

struct AccountView: View {

    @EnvironmentObject private var billsModel: BillsModel

    @State private var isPresentingAccountSettings: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if let user = billsModel.user {
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(Color(uiColor: .lightGray))
                                .background(Color.white)
                                .clipShape(Circle())

                            Text(user.name)
                                .font(.title2)

                            Text(verbatim: user.email)
                                .font(.callout)
                                .foregroundColor(.secondary)

                            Text(verbatim: user.id)
                                .font(.callout)
                                .italic()
                                .foregroundColor(.secondary)
                                .contextMenu {
                                    Button {
                                        UIPasteboard.general.string = user.id
                                    } label: {
                                        Label("Copy", systemImage: "doc.on.doc")
                                    }
                                }
                        }

                        Button {
                            isPresentingAccountSettings = true
                        } label: {
                            HStack {
                                Text("Manage Account Settings")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Account")
            .safeAreaInset(edge: .bottom) {
                Button("Sign Out") {
                    billsModel.signOut()
                }
                .padding(24)
            }
        }
        .sheet(isPresented: $isPresentingAccountSettings) {
            AccountSettingsView()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
