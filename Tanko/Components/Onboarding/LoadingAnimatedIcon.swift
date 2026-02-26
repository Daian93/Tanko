//
//  LoadingAnimatedIcon.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct LoadingAnimatedIcon: View {
    let isAnimating: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 120, height: 120)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .opacity(isAnimating ? 0.3 : 0.8)

            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 100, height: 100)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .opacity(isAnimating ? 0.5 : 1.0)

            Image(systemName: "books.vertical.fill")
                .font(.system(size: 50))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
        }
        .animation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true),
            value: isAnimating
        )
    }
}

#Preview {
    LoadingAnimatedIcon(isAnimating: true)
        .background(.tankoPrimary.opacity(0.7))
}
