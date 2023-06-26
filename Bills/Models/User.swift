//
//  User.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation

struct User: Identifiable, Hashable {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var photoURL: URL?

    var nameComponents: PersonNameComponents? {
        try? PersonNameComponents(name)
    }
}

extension User {
    static var empty: User {
        User(
            id: UUID().uuidString,
            name: "User",
            email: "",
            photoURL: nil
        )
    }
}

#if canImport(Firebase)
import Firebase

extension User {
    init(_ firUser: Firebase.User) {
        self.id = firUser.uid
        self.name = firUser.displayName ?? ""
        self.email = firUser.email ?? ""
        self.photoURL = firUser.photoURL
    }
}
#endif

extension User {
    init(_ userDto: UserDTO) {
        self.id = userDto.uid
        self.email = userDto.email
        self.name = userDto.name
        self.photoURL = URL(string: userDto.photoUrl ?? "")
    }
}

extension User {
    init(_ userMetadataDto: UserMetadataDTO) {
        self.id = userMetadataDto.uid
        self.email = ""
        self.name = userMetadataDto.name
        self.photoURL = URL(string: userMetadataDto.photoUrl ?? "")
    }
}
