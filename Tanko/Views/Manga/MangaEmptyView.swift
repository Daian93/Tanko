//
//  MangaEmptyView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaEmptyView: View {
    let onRetry: () async -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ContentUnavailableView(
                    "empty.title",
                    systemImage: "book.closed.fill",
                    description: Text("empty.description")
                )

                RetryButton(onRetry: onRetry)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .padding(.top, 250)
        }
        .background(.tankoBackground)
        .refreshable { await onRetry() }
    }
}

#Preview("Empty") {
    MangaEmptyView(onRetry: {})
}
