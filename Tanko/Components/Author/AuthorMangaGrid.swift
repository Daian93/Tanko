//
//  AuthorMangaGrid.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct AuthorMangaGrid: View {
    let mangas: [Manga]
    let columns: [GridItem]
    let cardWidth: CGFloat
    let canLoadMore: Bool
    let onLoadMore: (Manga) -> Void

    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(mangas) { manga in
                NavigationLink(value: MangaNavigation.withoutTransition(manga)) {
                    MangaCardPortrait(manga: manga, width: cardWidth)
                }
                .buttonStyle(.plain)
                .onAppear { onLoadMore(manga) }
            }

            if canLoadMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .gridCellColumns(columns.count)
            }
        }
    }
}

#Preview {
    let spacing: CGFloat = 30
    let cardWidth = (390 - 80 - spacing * 2) / 3
    let columns = Array(repeating: GridItem(.fixed(cardWidth), spacing: spacing), count: 3)
    ScrollView {
        AuthorMangaGrid(
            mangas: [.test],
            columns: columns,
            cardWidth: cardWidth,
            canLoadMore: false
        ) { _ in }
        .padding(.horizontal, 40)
    }
}
