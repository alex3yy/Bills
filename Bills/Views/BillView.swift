//
//  BillView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillView: View {
    private let services = ["Internet", "Telefonie mobila", "Telefonie fixa", "Energie electrica", "Abonament TV"]

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("DIGI")
                    .font(.headline)

                ForEach(0...0, id: \.self) { _ in
                    Text(services.randomElement()!)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("29.99 Lei")
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
    }
}
