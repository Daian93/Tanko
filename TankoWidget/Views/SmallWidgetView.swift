//
//  SmallWidgetView.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import SwiftUI

struct SmallWidgetView: View {
    let manga: ReadingManga?

    var body: some View {
        if let manga {
            MangaCardWidget(manga: manga)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            EmptyStateView()
        }
    }
}
