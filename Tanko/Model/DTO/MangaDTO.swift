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

extension MangaDTO {
    static let testDTO = MangaDTO(
        id: 1,
        title: "Monster",
        titleEnglish: "Monster",
        titleJapanese: "MONSTER",
        mainPicture: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg",
        sypnosis: "Test synopsis",
        background: nil,
        score: 9.15,
        status: "finished",
        chapters: 162,
        volumes: 18,
        startDate: "1994-12-05",
        endDate: "2001-12-20",
        url: "https://myanimelist.net/manga/1/Monster",
        genres: [.test],
        themes: [.test],
        demographics: [.test],
        authors: [.test]
    )

}
