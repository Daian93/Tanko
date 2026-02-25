//
//  MangaCardInfo.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaCardInfo: View {
    let manga: Manga

    var body: some View {
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
}

#Preview {
    MangaCardInfo(manga: .test)
        .background(.black.opacity(0.7))
}

