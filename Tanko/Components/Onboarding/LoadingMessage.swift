//
//  LoadingMessage.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct LoadingMessage: View {
    let message: LocalizedStringKey
    let showSubtitle: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            if showSubtitle {
                Text("loading.subtext")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    LoadingMessage(message: "Sincronizando tu colección...", showSubtitle: true)
        .padding()
        .background(.tankoPrimary.opacity(0.7))
}
