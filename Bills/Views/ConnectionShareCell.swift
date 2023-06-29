//
//  ConnectionShareCell.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import SwiftUI

struct ConnectionShareCell: View {

    var connection: Connection

    @Binding var isShared: Bool

    var body: some View {
        Toggle(isOn: $isShared) {
            PersonCardView(user: connection.user)
        }
        .toggleStyle(.checklist)
    }
}

struct ConnectionShareCell_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }

    private struct Container: View {
        @State private var isOn: Bool = false

        var body: some View {
            ConnectionShareCell(
                connection: Connection(
                    user: User(
                        id: "",
                        name: "John Appleseed",
                        email: "",
                        photoURL: nil
                    ),
                    role: .tenant
                ),
                isShared: $isOn
            )
        }
    }
}
