//
//  MangaGridCard.swift
//  Tanko
//

import SwiftUI

struct MangaGridCard: View {

    let manga: Manga
    private let cardSize: CGFloat = 170

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {

                // Manga main picture with placeholder
                AsyncImage(url: manga.mainPicture) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardSize, height: cardSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    Color.surface
                        .frame(width: cardSize, height: cardSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            Image(systemName: "book")
                                .font(.largeTitle)
                                .foregroundStyle(.tankoPrimary)
                        )
                }

                MangaStatusBadge(status: manga.status)
                    .padding(6)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundStyle(.textPrimary)

                MangaRatingView(score: manga.formattedScore)
                    .font(.caption)
                    .foregroundStyle(.textSecondary)
            }
            .frame(width: cardSize, alignment: .leading)
        }
    }
}

#Preview {
    MangaGridCard(manga: .test)
        .padding()
}
