//
//  PersonCardView.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

struct PersonCardView: View {

    var user: User

    var body: some View {
        HStack {
            AsyncImage(url: user.photoURL, transaction: .init(animation: .easeInOut(duration: 0.25))) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    ZStack {
                        Color.gray.opacity(0.1)
                        Image(systemName: "person")
                            .resizable()
                            .padding()
                    }
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())

            Text(user.name)
                .font(.system(size: 17))
                .fontWeight(.semibold)
        }
    }
}

struct PersonCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonCardView(user: User(id: "1", name: "John Appleseed", email: "", photoURL: nil))
                .previewDisplayName("Person w/o picture")

            PersonCardView(user: User(id: "1", name: "Dwayne \"The Rock\" Johnson", email: "", photoURL: URL(string: "https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg")))
                .previewDisplayName("Person w picture")
        }
    }
}
