//
//  LargeWidgetView.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import SwiftUI

struct LargeWidgetView: View {
    let mangas: [ReadingManga]

    var body: some View {
        if mangas.isEmpty {
            EmptyStateView()
        } else {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: WidgetTheme.Spacing.cardPadding),
                    GridItem(.flexible(), spacing: WidgetTheme.Spacing.cardPadding)
                ],
                spacing: WidgetTheme.Spacing.cardPadding
            ) {
                ForEach(mangas.prefix(4)) { manga in
                    MangaCardWidget(manga: manga)
                        .aspectRatio(0.95, contentMode: .fit)
                }
            }
            .padding(WidgetTheme.Spacing.cardPadding)
        }
    }
}
