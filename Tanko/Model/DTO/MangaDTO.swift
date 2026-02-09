//
//  MangaDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 19/1/26.
//

import Foundation

struct MangaDTO: Codable, Identifiable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let mainPicture: String?
    let sypnosis: String?
    let background: String?
    let score: Double
    let status: String?
    let chapters: Int?
    let volumes: Int?
    let startDate: String?
    let endDate: String?
    let url: String?
    let genres: [GenreDTO]
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]
    let authors: [AuthorDTO]
}

extension MangaDTO {
    var toManga: Manga {
        Manga(
            id: id,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            mainPicture: mainPicture.flatMap { URL(string: $0.cleanedURL) },
            synopsis: sypnosis ?? String(localized: "synopsis.not.available"),
            background: background ?? String(localized: "background.not.available"),
            score: score,
            status: MangaStatus(rawValue: status ?? "") ?? .none,
            chapters: chapters,
            volumes: volumes,
            startDate: startDate?.toDate(),
            endDate: endDate?.toDate(),
            url: url.flatMap { URL(string: $0.cleanedURL) },
            genres: genres.compactMap { $0.genreType },
            themes: themes.compactMap { $0.themeType },
            demographics: demographics.compactMap { $0.demographicType },
            authors: authors.map { $0.toAuthor }
        )
    }
}
