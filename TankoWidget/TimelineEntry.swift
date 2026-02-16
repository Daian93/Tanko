//
//  TimelineEntry.swift
//  TankoWidgetExtension
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import SwiftUI
import WidgetKit

struct MangaEntry: TimelineEntry {
    var date: Date
    var mangas: [ReadingManga]
}

extension ReadingManga {
    static let monsterTest = ReadingManga(
        id: 1,
        title: "Monster",
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"
        ),
        readingVolume: 2,
        totalVolumes: 18
    )

    static let berserkTest = ReadingManga(
        id: 2,
        title: "Berserk",
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/1/157897l.jpg"
        ),
        readingVolume: 1,
        totalVolumes: nil
    )
    
    static let centuryBoysTest = ReadingManga(
        id: 3,
        title: "20th Century Boys",
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/5/260006l.jpg"
        ),
        readingVolume: 8,
        totalVolumes: 22
    )
    
    static let YokohamaKaidashiKikouTest = ReadingManga(
        id: 4,
        title: "Yokohama Kaidashi Kikou",
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/1/171813l.jpg"
        ),
        readingVolume: 13,
        totalVolumes: 14
    )
}

extension MangaEntry {
    static let test = MangaEntry(date: .now, mangas: [.monsterTest, .berserkTest])
}
