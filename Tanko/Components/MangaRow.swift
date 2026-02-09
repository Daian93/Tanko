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

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CoverView(cover: manga.mainPicture,namespace: namespace)
                .frame(width: 70, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 2)

            VStack(alignment: .leading, spacing: 6) {
                Text(manga.title)
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)

                Text(manga.authorNames)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
                
                Spacer(minLength: 20)

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.subheadline)
                        Text(manga.formattedScore)
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                    }

                    Spacer()

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
        .background(AppColors.surface, in: .rect(cornerRadius: 16))
    }
}

#Preview() {
    @Previewable @Namespace var namespace
    MangaRow(manga: .test, namespace: namespace)
        .frame(height: 100)
}
