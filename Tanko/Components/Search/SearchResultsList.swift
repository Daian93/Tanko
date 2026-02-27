//
//  SearchResultsList.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/2/26.
//

import SwiftUI

struct SearchResultsList: View {
    let results: [Manga]
    let canLoadMore: Bool
    let namespace: Namespace.ID
    let isInCollection: (Int) -> Bool
    let onLoadMore: (Manga) -> Void

    var body: some View {
        List {
            ForEach(Array(results.enumerated()), id: \.element.id) {
                index,
                manga in
                let isFirst = index == 0
                let isLast = index == results.count - 1

                NavigationLink(value: MangaNavigation.withoutTransition(manga))
                {
                    MangaRow(
                        manga: manga,
                        namespace: namespace,
                        isInCollection: isInCollection(manga.id),
                        showBackground: false
                    )
                }
                .listRowSeparator(isFirst ? .hidden : .visible, edges: .top)
                .listRowSeparator(isLast ? .hidden : .visible, edges: .bottom)
                .listRowSeparatorTint(.surface)
                .listRowInsets(
                    EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 15)
                )
                .onAppear {
                    onLoadMore(manga)
                }
            }

            if canLoadMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - iPad variant (without isInCollection)

struct SearchResultsListiPad: View {
    let results: [Manga]
    let canLoadMore: Bool
    let namespace: Namespace.ID
    let onLoadMore: (Manga) -> Void

    @Environment(UserMangaCollectionViewModel.self) private var collectionVM

    var body: some View {
        List {
            ForEach(Array(results.enumerated()), id: \.element.id) {
                index,
                manga in
                let isFirst = index == 0
                let isLast = index == results.count - 1

                NavigationLink(value: MangaNavigation.withoutTransition(manga))
                {
                    MangaRow(
                        manga: manga,
                        namespace: namespace,
                        isInCollection: collectionVM.isInCollection(
                            mangaID: manga.id
                        ),
                        showBackground: false
                    )
                }
                .listRowSeparator(isFirst ? .hidden : .visible, edges: .top)
                .listRowSeparator(isLast ? .hidden : .visible, edges: .bottom)
                .listRowSeparatorTint(.surface)
                .listRowInsets(
                    EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 15)
                )
                .onAppear {
                    onLoadMore(manga)
                }
            }

            if canLoadMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    SearchResultsList(
        results: [.test],
        canLoadMore: false,
        namespace: namespace,
        isInCollection: { _ in false },
        onLoadMore: { _ in }
    )
}
