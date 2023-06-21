//
//  ConnectionsView.swift
//  Bills
//
//  Created by Alex Zaharia on 28.05.2023.
//

import SwiftUI

struct ConnectionsView: View {

    var body: some View {
        NavigationStack {
            Text("Connections List View")
            .navigationTitle("Connections")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //
                    } label: {
                        Label("Bell", systemImage: "bell")
                            .labelStyle(.iconOnly)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //
                    } label: {
                        Label("Plus", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}
