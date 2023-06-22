//
//  View+IconBadge.swift
//  Bills
//
//  Created by Alex Zaharia on 22.06.2023.
//

import SwiftUI

extension View {
    func iconBadge(_ count: Int) -> some View {
        modifier(IconBadgeViewModifier(count: count))
    }
}

struct IconBadgeViewModifier: ViewModifier {

    let count: Int

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if count > 0 {
                    Text(count.formatted())
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(minWidth: 10)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 4)
                        .background(.red, in: Capsule())
                        .offset(x: 6, y: -6)
                        .fixedSize()
                }
            }
    }
}
