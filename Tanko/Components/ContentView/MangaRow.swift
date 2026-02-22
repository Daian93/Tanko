//
//  MangaRow.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

struct MangaRow: View {
    let manga: Manga
    let namespace: Namespace.ID

    var isInCollection: Bool = false
    var onBookmarkTap: (() -> Void)? = nil
    var showBackground: Bool = true

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // Manga cover with matched geometry effect for smooth transition to detail view
            CoverView(cover: manga.mainPicture, namespace: namespace)
                .frame(width: 70, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    // Manga title
                    Text(manga.title)
                        .font(.headline)
                        .foregroundStyle(.textPrimary)
                        .lineLimit(2)

                    Spacer()

                    // Bookmark icon if manga is in user's collection, tappable to trigger bookmark action
                    if isInCollection {
                        Image(systemName: "bookmark.plus")
                            .foregroundStyle(.tankoPrimary)
                            .padding(.trailing, 2)
                    }
                }

                // Manga authors
                Text(manga.authorNames)
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)
                    .lineLimit(1)

                Spacer(minLength: 20)

                HStack {
                    // Manga score/
                    MangaRatingView(score: manga.formattedScore)
                        .font(.subheadline)
                        .foregroundStyle(.textSecondary)

                    Spacer()

                    // Manga status
                    Text(manga.status.localized)
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(manga.status.color)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(
            showBackground ? .surface : Color.clear,
            in: .rect(cornerRadius: 16)
        )
    }
}

#Preview() {
    @Previewable @Namespace var namespace
    MangaRow(manga: .test, namespace: namespace, isInCollection: true)
        .frame(height: 100)
}
