//
//  UserInvitationView.swift
//  Bills
//
//  Created by Alex Zaharia on 21.06.2023.
//

import SwiftUI

struct UserInvitationView: View {
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .padding()
                .frame(width: 70, height: 70)
                .background(.gray.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8) {
                Text("John Appleseed")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                Text("Wants to add you to his managed domain.")
                    .font(.subheadline)
            }

            Spacer()

            Button {

            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.borderedProminent)

            Button(role: .destructive) {

            } label: {
                Image(systemName: "xmark")
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct UserInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInvitationView()
            .padding()
    }
}
