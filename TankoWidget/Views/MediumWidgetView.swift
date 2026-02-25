//
//  MediumWidgetView.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import SwiftUI

struct MediumWidgetView: View {
    let mangas: [ReadingManga]

    var body: some View {
        if mangas.isEmpty {
            EmptyStateView()
        } else {
            HStack(spacing: WidgetTheme.Spacing.cardSpacing) {
                ForEach(mangas.prefix(2)) { manga in
                    MangaCardWidget(manga: manga)
                }
            }
            .padding(WidgetTheme.Spacing.cardPadding)
        }
    }
}
