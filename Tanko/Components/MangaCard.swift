//
//  MangaCard.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

struct MangaCard: View {
    let manga: Manga
    let namespace: Namespace.ID

    private let width: CGFloat = 300
    private let height: CGFloat = 170

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .frame(width: width, height: height)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(gradientOverlay) } placeholder: {
                Color.gray.opacity(0.3)
            }

            VStack {
                HStack {
                    Spacer()
                    statusBadge
                }
                Spacer()
            }
            .padding(12)

            infoOverlay
        }
        .frame(width: width, height: height)
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.85),
                .black.opacity(0.4),
                .clear
            ],
            startPoint: .bottom,
            endPoint: .top
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var infoOverlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(manga.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundStyle(.white)

            Text(firstAuthor)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                Text(manga.formattedScore)
            }
            .font(.subheadline)
            .foregroundColor(.yellow)
        }
        .padding(12)
    }

    private var firstAuthor: String {
        manga.authorNames
            .split(separator: ",")
            .first
            .map(String.init) ?? ""
    }

    private var statusBadge: some View {
        Text(manga.status.localized)
            .font(.caption)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(manga.status.color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

#Preview {
    @Previewable @Namespace var namespace
    MangaCard(manga: .test, namespace: namespace)
}

