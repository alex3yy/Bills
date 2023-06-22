//
//  BillsView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillsView: View {
    @EnvironmentObject private var navigationModel: NavigationModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(0...5, id: \.self) { billId in
                    NavigationLink {
                        Text("Bill Detail View")
                    } label: {
                        BillView()
                    }
                    .contextMenu {
                        Button {
                            navigationModel.presentConnectionsListView(for: Bill(id: billId.formatted()))
                        } label: {
                            Label("Share with...", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .navigationTitle("Bills")
            .sheet(item: $navigationModel.selectedBillForSharing) { bill in
                NavigationStack {
                    BillShareView(bill: bill)
                        .navigationTitle("Share Bill")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done", role: .cancel) {
                                    navigationModel.dismissConnectionsListView()
                                }
                            }
                        }
                }
            }
        }
    }
}

struct BillsView_Previews: PreviewProvider {
    static var previews: some View {
        BillsView()
            .environmentObject(NavigationModel())
    }
}
