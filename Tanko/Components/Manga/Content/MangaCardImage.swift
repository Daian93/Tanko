//
//  MangaCardImage.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaCardImage: View {
    let url: URL?
    let size: CGSize

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(gradientOverlay)
        } placeholder: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.3))
                .frame(width: size.width, height: size.height)
        }
    }

    // Black gradient overlay to improve text readability on top of the image
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
}

#Preview("With image URL") {
    MangaCardImage(
        url: URL(string: "https://cdn.myanimelist.net/images/manga/3/249658l.jpg"),
        size: CGSize(width: 300, height: 170)
    )
}
