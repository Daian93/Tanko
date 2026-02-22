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
                    "content.empty.title",
                    systemImage: "book.closed",
                    description: Text("content.empty.description")
                )

                RetryButton(onRetry: onRetry)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .padding(.top, 200)
        }
        .background(.tankoBackground)
        .refreshable { await onRetry() }
    }
}

#Preview("Empty") {
    MangaEmptyView(onRetry: {})
}
