//
//  TankoTimeline.swift
//  TankoWidgetExtension
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import SwiftUI
import WidgetKit

struct TankoTimeline: TimelineProvider {
    typealias Entry = MangaEntry

    func placeholder(in context: Context) -> MangaEntry {
        .test
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (MangaEntry) -> Void
    ) {
        completion(.test)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MangaEntry>) -> Void) {
        Task(priority: .high) {
            let collection = await WidgetDataManager.shared.load()
            
            for manga in collection.mangas {
                if let url = manga.coverURL {
                    _ = try? await ImageDownloader.shared.image(for: url)
                }
            }

            var entries: [MangaEntry] = []
            let currentDate = Date()

            for minuteOffset in stride(from: 0, to: 60, by: 5) {
                let entryDate = Calendar.current.date(
                    byAdding: .minute,
                    value: minuteOffset,
                    to: currentDate
                ) ?? currentDate

                let entry = MangaEntry(
                    date: entryDate,
                    mangas: collection.mangas
                )

                entries.append(entry)
            }

            let timeline = Timeline(
                entries: entries,
                policy: .atEnd
            )

            completion(timeline)
        }
    }
}
