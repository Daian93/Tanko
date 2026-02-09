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

    private let cardSize: CGFloat = 160 // tamaño cuadrado

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {

                // Imagen de portada
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
                                .foregroundStyle(.white.opacity(0.6))
                        )
                }
                .matchedGeometryEffect(id: "cover-\(manga.id)", in: namespace)

                // Estado arriba a la derecha
                statusBadge
                    .padding(6)
            }

            // Título y puntuación debajo del cuadrado
            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(AppColors.textPrimary)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(manga.formattedScore)
                }
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
            }
            .frame(width: cardSize, alignment: .leading)
        }
    }

    private var statusBadge: some View {
        Text(manga.status.localized)
            .font(.caption2)
            .bold()
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(manga.status.color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

#Preview {
    @Previewable @Namespace var namespace
    MangaGridCard(manga: .test, namespace: namespace)
        .padding()
}

