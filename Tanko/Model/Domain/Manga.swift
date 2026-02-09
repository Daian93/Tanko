//
//  Manga.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation
import SwiftUI

struct Manga: Identifiable, Hashable, Codable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let mainPicture: URL?
    let synopsis: String
    let background: String?
    let score: Double
    let status: MangaStatus
    let chapters: Int?
    let volumes: Int?
    let startDate: Date?
    let endDate: Date?
    let url: URL?
    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]
    let authors: [Author]
}

extension Manga {
    var formattedScore: String {
        String(format: "%.2f", score)
    }

    var publicationYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"

        let start = startDate.map { formatter.string(from: $0) } ?? "?"
        let end =
            endDate.map { formatter.string(from: $0) }
            ?? (status == .finished ? "?" : "Presente")

        return "\(start) - \(end)"
    }

    var authorNames: String {
        authors.map { $0.fullName }.joined(separator: ", ")
    }

    var genreNames: String {
        genres.map { $0.rawValue }.joined(separator: ", ")
    }

    var demographicsNames: String {
        demographics.map { $0.rawValue }.joined(separator: ", ")
    }

    var themeNames: String {
        themes.map { $0.rawValue }.joined(separator: ", ")
    }
}

extension Manga {
    static let test = Manga(
        id: 1,
        title: "Monster",
        titleEnglish: "Monster",
        titleJapanese: "MONSTER",
        mainPicture: URL(
            string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"
        ),
        synopsis:
            "Kenzou Tenma, a renowned Japanese neurosurgeon working in post-war Germany, faces a difficult choice: to operate on Johan Liebert, an orphan boy on the verge of death, or on the mayor of Düsseldorf. In the end, Tenma decides to gamble his reputation by saving Johan, effectively leaving the mayor for dead.\n\nAs a consequence of his actions, hospital director Heinemann strips Tenma of his position, and Heinemann's daughter Eva breaks off their engagement. Disgraced and shunned by his colleagues, Tenma loses all hope of a successful career—that is, until the mysterious killing of Heinemann gives him another chance.\n\nNine years later, Tenma is the head of the surgical department and close to becoming the director himself. Although all seems well for him at first, he soon becomes entangled in a chain of gruesome murders that have taken place throughout Germany. The culprit is a monster—the same one that Tenma saved on that fateful day nine years ago.\n\n[Written by MAL Rewrite]",
        background:
            "Monster won the Grand Prize at the 3rd annual Tezuka Osamu Cultural Prize in 1999, as well as the 46th Shogakukan Manga Award in the General category in 2000. The series was published in English by VIZ Media under the VIZ Signature imprint from February 21, 2006 to December 16, 2008, and again in 2-in-1 omnibuses (subtitled The Perfect Edition) from July 15, 2014 to July 19, 2016. The manga was also published in Brazilian Portuguese by Panini Comics/Planet Manga from June 2012 to April 2015, in Polish by Hanami from March 2014 to February 2017, in Spain by Planeta Cómic from June 16, 2009 to September 21, 2010, and in Argentina by LARP Editores.",
        score: 9.15,
        status: .finished,
        chapters: 162,
        volumes: 18,
        startDate: ISO8601DateFormatter().date(from: "1994-12-05T00:00:00Z"),
        endDate: ISO8601DateFormatter().date(from: "2001-12-20T00:00:00Z"),
        url: URL(string: "https://myanimelist.net/manga/1/Monster"),
        genres: [.awardWinning, .drama, .mystery],
        themes: [.adultCast, .psychological],
        demographics: [.seinen],
        authors: [
            Author(
                id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!,
                fullName: "Naoki Urasawa",
                role: .storyAndArt
            )
        ]
    )
}

enum MangaStatus: String, Codable, CaseIterable{
    case discontinued = "discontinued"
    case onHiatus = "on_hiatus"
    case currentlyPublishing = "currently_publishing"
    case finished = "finished"
    case none = "none"
}

extension MangaStatus {
    var localizedKey: String {
        switch self {
        case .currentlyPublishing: return "status.publishing"
        case .finished: return "status.finished"
        case .onHiatus: return "status.hiatus"
        case .discontinued: return "status.discontinued"
        case .none: return "status.unknown"
        }
    }
    
    var localized: LocalizedStringKey {
        LocalizedStringKey(localizedKey)
    }

    var color: Color {
        switch self {
        case .currentlyPublishing: return .green
        case .finished: return .blue
        case .onHiatus: return .orange
        case .discontinued: return .red
        case .none: return .gray
        }
    }
}
