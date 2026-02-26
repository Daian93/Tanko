//
//  AuthError.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct AuthErrorView: View {
    let error: AuthError

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.tankoPrimary)

            Text(error.localizedDescription)
                .font(.footnote)
                .foregroundStyle(.tankoPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.tankoPrimary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    AuthErrorView(error: .invalidCredentials)
        .padding()
}


