//
//  BillView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct BillView: View {

    var bill: Bill

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(bill.provider.rawValue.capitalized)
                    .font(.headline)

                VStack(alignment: .leading) {
                    ForEach(bill.services) { service in
                        Text(service.title)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            Text(bill.price, format: .currency(code: "RON"))
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView(bill: Bill(
            id: "1",
            client: .init(id: "u1", name: "John Appleseed"),
            provider: .digi,
            services: [
                .init(id: "s1", title: "Serv. reparatii", price: 20, currencyCode: "RON")
            ],
            currencyCode: "RON"))
    }
}
