//
//  MangaGridCard.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 8/2/26.
//

import SwiftUI

struct MangaGridCard: View {

    let manga: Manga
    let namespace: Namespace.ID

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
                    Color.gray.opacity(0.2)
                        .frame(width: cardSize, height: cardSize)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            Image(systemName: "book")
                                .font(.largeTitle)
                                .foregroundStyle(.tankoPrimary)
                        )
                }
                .matchedGeometryEffect(id: "cover-\(manga.id)", in: namespace)

                // Manga status
                MangaStatusBadge(status: manga.status)
                    .padding(6)
            }

            // Title and score under the cover
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
    @Previewable @Namespace var namespace
    MangaGridCard(manga: .test, namespace: namespace)
        .padding()
}
