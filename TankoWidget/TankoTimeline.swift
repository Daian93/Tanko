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

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<MangaEntry>) -> Void
    ) {
        Task(priority: .high) {
            let collection = await WidgetDataManager.shared.load()
            let mangas = collection.mangas

            for manga in mangas {
                if let url = manga.coverURL {
                    _ = try? await ImageDownloader.shared.image(for: url)
                }
            }

            let intervalInMinutes: Int
            switch mangas.count {
            case 0...5: intervalInMinutes = 240
            case 6...20: intervalInMinutes = 60
            default: intervalInMinutes = 30
            }

            let currentDate = Date()
            var entries: [MangaEntry] = []

            guard !mangas.isEmpty else {
                let entry = MangaEntry(date: currentDate, mangas: [])
                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(currentDate.addingTimeInterval(60 * 60))
                )
                completion(timeline)
                return
            }

            for minuteOffset in stride(from: 0, to: 720, by: intervalInMinutes) {

                let entryDate =
                    Calendar.current.date(
                        byAdding: .minute,
                        value: minuteOffset,
                        to: currentDate
                    ) ?? currentDate

                let maxItems: Int
                switch context.family {
                case .systemSmall: maxItems = 1
                case .systemMedium: maxItems = 2
                case .systemLarge: maxItems = 4
                default: maxItems = 1
                }

                let total = mangas.count
                let displayCount = min(maxItems, total)

                let rotationIndex = (minuteOffset / intervalInMinutes) % total

                var selectedMangas: [ReadingManga] = []

                for offset in 0..<displayCount {
                    let index = (rotationIndex + offset) % total
                    selectedMangas.append(mangas[index])
                }

                let entry = MangaEntry(date: entryDate, mangas: selectedMangas)
                entries.append(entry)
            }

            
            let timeline = Timeline(entries: entries, policy: .atEnd)

            completion(timeline)
        }
    }
}
