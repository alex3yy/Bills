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
            List {
                ForEach(0...5, id: \.self) { _ in
                    NavigationLink {
                        Text("Bill Detail View")
                    } label: {
                        BillView()
                    }
                }
            }
        }
    }
}

struct BillsView_Previews: PreviewProvider {
    static var previews: some View {
        BillsView()
    }
}
