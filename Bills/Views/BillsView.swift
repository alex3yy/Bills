//
//  BillsView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillsView: View {
    var body: some View {
        NavigationStack {
            Text("Bills List")
                .navigationTitle("Bills")
        }
    }
}

struct BillsView_Previews: PreviewProvider {
    static var previews: some View {
        BillsView()
    }
}
