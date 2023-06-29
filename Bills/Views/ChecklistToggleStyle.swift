//
//  ChecklistToggleStyle.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import SwiftUI

struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn
                      ? "checkmark.circle.fill"
                      : "circle")
                .font(.title2)
                .foregroundColor(.accentColor)
            }
        }
        .tint(.primary)
        .buttonStyle(.borderless)
    }
}

extension ToggleStyle where Self == ChecklistToggleStyle {
    static var checklist: ChecklistToggleStyle { .init() }
}

struct ChecklistToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }

    private struct Container: View {
        @State private var isOn: Bool = false

        var body: some View {
            Toggle(isOn: $isOn) {
                Text("It's me!")
            }
            .toggleStyle(.checklist)
        }
    }
}
