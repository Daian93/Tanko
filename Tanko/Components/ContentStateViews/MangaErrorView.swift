//
//  MangaErrorView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaErrorView: View {
    let message: String
    let onRetry: () async -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 60))
                    .foregroundStyle(.tankoSecondary)

                Text("no.connection")
                    .font(.title2.bold())

                Text(message)
                    .foregroundStyle(.tankoSecondary)
                    .multilineTextAlignment(.center)

                RetryButton(onRetry: onRetry)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 200)
            .padding(.horizontal)
        }
        .background(.tankoBackground)
        .refreshable { await onRetry() }
    }
}

#Preview("Error") {
    MangaErrorView(message: "Could not connect to the server") {}
}
