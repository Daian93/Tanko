//
//  AuthSubmitButton.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct AuthSubmitButton: View {
    let label: LocalizedStringKey
    let isLoading: Bool
    let isFormValid: Bool
    let maxWidth: CGFloat
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(label)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: maxWidth)
            .padding()
            .background(
                isFormValid && !isLoading
                    ? .tankoPrimary
                    : Color.gray.opacity(0.5)
            )
            .foregroundStyle(.tankoBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isFormValid || isLoading)
        .padding(.top, 2)
        #if os(macOS)
            .buttonStyle(.plain)
        #endif
    }
}

#Preview {
    AuthSubmitButton(
        label: "auth.login",
        isLoading: false,
        isFormValid: true,
        maxWidth: .infinity,
        action: {}
    )
    .padding()
}
