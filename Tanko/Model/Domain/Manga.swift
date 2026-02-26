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

    var publicationStartYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return startDate.map { formatter.string(from: $0) } ?? "?"
    }

    var publicationEndYear: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return endDate.map { formatter.string(from: $0) }
    }

    var isOngoing: Bool {
        endDate == nil && status != .finished
    }

    var publicationYear: String {
        let end =
            publicationEndYear
            ?? (isOngoing ? String(localized: "date.present") : "?")
        return "\(publicationStartYear) - \(end)"
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

enum MangaStatus: String, Codable, CaseIterable {
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
