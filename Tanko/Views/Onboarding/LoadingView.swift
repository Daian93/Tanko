//
//  LoadingView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var showMessage = false

    let message: LocalizedStringKey

    init(message: LocalizedStringKey = "loading.text.user") {
        self.message = message
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    .tankoPrimary.opacity(0.8),
                    .tankoSecondary.opacity(0.6),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                LoadingAnimatedIcon(isAnimating: isAnimating)

                LoadingMessage(message: message, showSubtitle: showMessage)

                // Progress indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding(.top, 20)

                Spacer()

                LoadingBranding()
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }

            // Show additional message after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showMessage = true
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}

#Preview("With custom message") {
    LoadingView(message: "Cargando tu biblioteca...")
}
