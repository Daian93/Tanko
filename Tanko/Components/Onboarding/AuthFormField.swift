//
//  AuthFormField.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct AuthTextField: View {
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline.bold())
                .foregroundStyle(.tankoSecondary)

            TextField(placeholder, text: $text)
                .keyboardTypeCompatible(.emailAddress)
                .textInputAutocapitalizationCompatible()
                .textContentTypeCompatible(.username)
                .padding()
                .background(.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct AuthSecureField: View {
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline.bold())
                .foregroundStyle(.tankoSecondary)

            SecureField(placeholder, text: $text)
                .textContentType(.password)
                .padding()
                .background(.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        AuthTextField(label: "Email", placeholder: "Enter your email", text: .constant(""))
        AuthSecureField(label: "Password", placeholder: "Enter your password", text: .constant(""))
    }
    .padding()
}
