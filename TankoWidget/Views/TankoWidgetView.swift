//
//  TankoWidgetEntryView.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import SwiftUI
import WidgetKit

struct TankoWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: MangaEntry

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWidgetView(manga: entry.mangas.first)
            case .systemMedium:
                MediumWidgetView(mangas: entry.mangas)
            case .systemLarge:
                LargeWidgetView(mangas: entry.mangas)
            default:
                SmallWidgetView(manga: entry.mangas.first)
            }
        }
    }
}
