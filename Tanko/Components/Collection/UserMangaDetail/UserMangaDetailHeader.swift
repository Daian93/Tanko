//
//  UserMangaDetailHeader.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI

struct UserMangaDetailHeader: View {
    let coverURL: URL?
    let title: String
    let namespace: Namespace.ID?
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Manga cover with transition
            CoverView(cover: coverURL, namespace: namespace, big: true)
                .frame(width: 120, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                
                Text(title)
                    .font(.title2.bold())
                    .lineLimit(4)
                    .minimumScaleFactor(0.9)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(height: 180)
        .background(.tankoBackground)
    }
}

#Preview {
    UserMangaDetailHeader(
        coverURL: URL(string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"),
        title: "Monster",
        namespace: nil
    )
}
