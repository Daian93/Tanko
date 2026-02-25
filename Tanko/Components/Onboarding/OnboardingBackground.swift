//
//  OnboardingBackground.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct OnboardingBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                .tankoPrimary.opacity(0.9),
                .tankoSecondary.opacity(0.7),
                .tankoPrimary.opacity(0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingBackground()
}
