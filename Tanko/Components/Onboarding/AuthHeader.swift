//
//  AuthHeader.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct AuthHeader: View {
    let icon: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    var topPadding: CGFloat = 15

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.tankoPrimary.opacity(0.1))
                    .frame(width: 80, height: 80)

                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundStyle(.tankoPrimary)
            }

            Text(title)
                .font(.title.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.tankoSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, topPadding)
    }
}

#Preview {
    AuthHeader(
        icon: "person.fill",
        title: "Bienvenido a Tanko",
        subtitle: "Inicia sesión para acceder a tu biblioteca y estadísticas personalizadas."
    )
}
        
