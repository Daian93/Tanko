//
//  AuthorMangaCarousel.swift
//  Tanko
//

import SwiftUI

struct AuthorMangaCarousel: View {
    let mangas: [Manga]
    let cardHeight: CGFloat
    let horizontalInset: CGFloat
    let canLoadMore: Bool
    let onLoadMore: (Manga) async -> Void

    private let spacing: CGFloat = 40

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: spacing) {
                ForEach(mangas) { manga in
                    NavigationLink(value: manga) {
                        MangaCardLandscape(manga: manga, height: cardHeight)
                            .task { await onLoadMore(manga) }
                    }
                    .buttonStyle(.plain)
                }

                if canLoadMore {
                    ProgressView()
                        .frame(width: 150)
                }
            }
            .padding(.horizontal, horizontalInset)
        }
        .frame(height: cardHeight + 100)
    }
}

#Preview {
    AuthorMangaCarousel(
        mangas: [.test],
        cardHeight: 300,
        horizontalInset: 60,
        canLoadMore: false
    ) { _ in }
}
