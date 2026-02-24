//
//  SearchStateViews.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/2/26.
//

import SwiftUI

// MARK: - Empty State (idle)

struct SearchEmptyState: View {
    var isIPad: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("search.title")
                .font(.title2)
                .fontWeight(.semibold)

            Text(
                isIPad
                    ? "search.subtext.ipad"
                    : "search.subtext.ios"
            )
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - No Results State

struct SearchNoResultsState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("search.noResults.title")
                .font(.title3)
                .fontWeight(.semibold)

            Text("search.noResults.subtitle")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Error State

struct SearchErrorState: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)

            Text("error.title")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("button.retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Loading State

struct SearchLoadingState: View {
    var body: some View {
        ProgressView("searching.caption")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Empty") {
    SearchEmptyState()
}

#Preview("No Results") {
    SearchNoResultsState()
}

#Preview("Error") {
    SearchErrorState(message: "Unable to connect to the server") {}
}
