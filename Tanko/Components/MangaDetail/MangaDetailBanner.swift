//
//  MangaDetailBanner.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct MangaDetailBanner: View {
    let manga: Manga
    let namespace: Namespace.ID?

    let bannerHeight: CGFloat = 200
    let coverOverlap: CGFloat = 80

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background blurred banner
            AsyncImage(url: manga.mainPicture) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: bannerHeight)
                        .opacity(0.5)
                        .clipped()
                } else {
                    LinearGradient(
                        colors: [.gray.opacity(0.2), .gray.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .frame(height: bannerHeight)
                    .clipped()
                }
            }

            // Cover + titles
            HStack(alignment: .bottom, spacing: 16) {
                CoverView(cover: manga.mainPicture, namespace: namespace, big: true)
                    .frame(width: 120, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 6)

                VStack(alignment: .leading, spacing: 1) {
                    Text(manga.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.70)

                    if let titleJapanese = manga.titleJapanese {
                        Text(titleJapanese)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    if let titleEng = manga.titleEnglish {
                        Text(titleEng)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .frame(height: 90, alignment: .bottom)

                Spacer()
            }
            .padding(.horizontal)
            .offset(y: coverOverlap)
            
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    MangaDetailBanner(manga: .test, namespace: namespace)
}
