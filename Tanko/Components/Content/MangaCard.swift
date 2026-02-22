//
//  MangaCard.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

struct MangaCard: View {
    let manga: Manga

    private let size = CGSize(width: 300, height: 170)

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MangaCardImage(
                url: manga.mainPicture,
                size: size
            )

            VStack {
                HStack {
                    Spacer()
                    MangaStatusBadge(status: manga.status)
                }
                Spacer()
            }
            .padding(12)

            MangaCardInfo(manga: manga)
        }
        .frame(width: size.width, height: size.height)
    }
}


#Preview {
    MangaCard(manga: .test)
}

