//
//  OnboardingLogo.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct OnboardingLogo: View {
    let isAnimating: Bool

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                Circle()
                    .fill(.white.opacity(0.3))
                    .frame(width: 120, height: 120)

                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 55))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
                    .animation(
                        .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            .padding(.bottom, 16)

            VStack(spacing: 12) {
                Text("app.name")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                Text("app.tagline")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
}

#Preview {
    OnboardingLogo(isAnimating: true)
        .background(.gray.opacity(0.8))
}
