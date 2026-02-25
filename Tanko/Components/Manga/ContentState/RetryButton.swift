//
//  RetryButton.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct RetryButton: View {
    let onRetry: () async -> Void

    var body: some View {
        Button {
            Task { await onRetry() }
        } label: {
            Label("button.retry", systemImage: "arrow.clockwise")
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.tankoPrimary.opacity(0.8))
                .clipShape(Capsule())
        }
    }
}

#Preview {
    RetryButton(onRetry: {})
}
