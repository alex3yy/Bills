//
//  RoundedProminentButtonStyle.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import SwiftUI

extension ButtonStyle where Self == RoundedProminentButtonStyle {

    /// A button style that applies a standard rounded prominent artwork.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    static var roundedProminent: RoundedProminentButtonStyle {
        RoundedProminentButtonStyle()
    }

    /// A button style that applies custom rounded prominent artwork with a custom color.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View/buttonStyle(_:)-66fbx`` modifier.
    static func roundedProminent(cornerRadius: CGFloat = 10, tint: Color = .accentColor) -> RoundedProminentButtonStyle {
        RoundedProminentButtonStyle(cornerRadius: cornerRadius, tint: tint)
    }
}

struct RoundedProminentButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 10
    var tint: Color = .accentColor

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .background(tint)
            .overlay(Color.white.opacity(configuration.isPressed ? 0.2 : 0))
            .cornerRadius(cornerRadius)
    }
}

struct RoundedProminentButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Sign In", action: {})
                .buttonStyle(.roundedProminent(cornerRadius: 10))
        }
    }
}
