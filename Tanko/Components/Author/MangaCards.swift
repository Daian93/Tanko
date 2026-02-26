//
//  MangaCards.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

// MARK: - MangaCardPortrait

struct MangaCardPortrait: View {
    let manga: Manga
    var width: CGFloat
    private var height: CGFloat { width * 1.3 }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                Color.surface
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        Image(systemName: "book")
                            .font(.title2)
                            .foregroundStyle(.tankoPrimary)
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(manga.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.yellow)
                    Text(manga.formattedScore)
                        .font(.caption2)
                        .foregroundStyle(.tankoSecondary)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(height: width * 1.5)
    }
}

// MARK: - MangaCardLandscape

struct MangaCardLandscape: View {
    let manga: Manga
    var height: CGFloat
    private var width: CGFloat { height * 0.7 }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                Group {
                    #if os(macOS)
                        Color.tankoSecondary.opacity(0.3)
                    #else
                        Color.surface
                    #endif
                }
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    Image(systemName: "book")
                        .font(.largeTitle)
                        .foregroundStyle(.tankoPrimary)
                )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text(manga.formattedScore)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.tankoSecondary)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(width: width, height: height + 80)
    }
}

#Preview {
    HStack(spacing: 20) {
        MangaCardPortrait(manga: .test, width: 120)
        MangaCardLandscape(manga: .test, height: 200)
    }
    .padding()
}
