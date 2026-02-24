//
//  TankoWidget.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import WidgetKit
import SwiftUI

struct TankoWidget: Widget {
    let kind: String = "TankoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TankoTimeline()) { entry in
            TankoWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    WidgetTheme.backgroundGradient
                }
        }
        .configurationDisplayName("widget.display.name")
        .description("widget.description")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Previews

#Preview(as: .systemSmall) {
    TankoWidget()
} timeline: {
    MangaEntry.test
}

#Preview(as: .systemMedium) {
    TankoWidget()
} timeline: {
    MangaEntry.test
}

#Preview(as: .systemLarge) {
    TankoWidget()
} timeline: {
    MangaEntry.test
}
