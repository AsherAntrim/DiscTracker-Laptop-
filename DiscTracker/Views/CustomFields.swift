//
//  CustomFields.swift
//  DiscTracker
//
//  Created by Asher Antrim on 12/9/24.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .foregroundColor(.primary)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .foregroundColor(.primary)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
