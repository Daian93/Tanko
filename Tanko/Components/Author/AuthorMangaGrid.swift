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
    let onLoadMore: (Manga) async -> Void

    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(mangas) { manga in
                NavigationLink(value: manga) {
                    MangaCardPortrait(manga: manga, width: cardWidth)
                        .task {
                            await onLoadMore(manga)
                        }
                }
                .buttonStyle(.plain)
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
