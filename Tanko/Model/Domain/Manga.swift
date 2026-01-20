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
            let end = endDate.map { formatter.string(from: $0) } ?? (status == .finished ? "?" : "Presente")

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

enum MangaStatus: String, Codable, CaseIterable {
    case discontinued = "discontinued"
    case onHiatus = "on_hiatus"
    case currentlyPublishing = "currently_publishing"
    case finished = "finished"
    case none = "none"
}

extension MangaStatus {
    var displayName: String {
        switch self {
        case .currentlyPublishing: return "En publicación"
        case .finished: return "Finalizado"
        case .onHiatus: return "En pausa"
        case .discontinued: return "Discontinuado"
        case .none: return "Desconocido"
        }
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
