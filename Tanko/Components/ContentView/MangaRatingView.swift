//
//  MangaRatingView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaRatingView: View {
    let score: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            Text(score)
        }
    }
}

#Preview {
    MangaRatingView(score: "8.5")
}

