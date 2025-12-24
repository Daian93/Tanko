//
//  ModelDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import Foundation

// MARK: - Enums

enum AuthorRole: String, Codable, CaseIterable {
    case art = "Art"
    case storyAndArt = "Story & Art"
    case story = "Story"
    case none = "None"
}

enum MangaStatus: String, Codable, CaseIterable {
    case discontinued = "discontinued"
    case onHiatus = "on_hiatus"
    case currentlyPublishing = "currently_publishing"
    case finished = "finished"
    case none = "none"
}

// MARK: - Auth DTOs

struct UsersCreate: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    let token: String
}

struct JWTTokenResponse: Codable {
    let token: String
    let tokenType: String
    let expiresIn: Int
}

// MARK: - User DTOs

struct UserResponse: Codable, Identifiable {
    let id: UUID
    let email: String
    let isActive: Bool
    let isAdmin: Bool
    let role: String
}

struct UserMangaCollectionRequest: Codable {
    let manga: Int
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
}

struct UserMangaCollectionDTO: Codable, Identifiable {
    let id: UUID
    let manga: MangaDTO
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
}

// MARK: - Manga DTOs

struct MangaDTO: Codable, Identifiable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let mainPicture: String?
    let sypnosis: String?
    let background: String?
    let score: Double
    let status: MangaStatus
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
            synopsis: sypnosis ?? "",
            background: background,
            score: score,
            status: status,
            chapters: chapters,
            volumes: volumes,
            startDate: startDate?.toDate(),
            endDate: endDate?.toDate(),
            url: url.flatMap { URL(string: $0.cleanedURL) },
            genres: genres.compactMap { $0.genreAsEnum },
            themes: themes.compactMap { $0.themeAsEnum },
            demographics: demographics.compactMap { $0.demographicAsEnum },
            authors: authors.map { $0.toAuthor }
        )
    }
}

struct MangaPageDTO: Codable {
    let metadata: PageMetadataDTO
    let items: [MangaDTO]
}

struct PageMetadataDTO: Codable {
    let total: Int
    let per: Int
    let page: Int
}

// MARK: - Related DTOs

struct AuthorDTO: Codable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let role: AuthorRole

    var fullName: String { "\(firstName) \(lastName)" }
}

extension AuthorDTO {
    var toAuthor: Author {
        Author(
            id: id,
            fullName: fullName,
            role: role
        )
    }
}

struct GenreDTO: Codable, Identifiable {
    let id: UUID
    let genre: String
}

extension GenreDTO {
    var genreAsEnum: Genre? {
        Genre(
            rawValue: genre
        )
    }
}

struct ThemeDTO: Codable, Identifiable {
    let id: UUID
    let theme: String
}

extension ThemeDTO {
    var themeAsEnum: Theme? {
        Theme(
            rawValue: theme
        )
    }
}

struct DemographicDTO: Codable, Identifiable {
    let id: UUID
    let demographic: String
}

extension DemographicDTO {
    var demographicAsEnum: Demographic? {
        Demographic(
            rawValue: demographic
        )
    }
}

// MARK: - Search DTO

struct CustomSearch: Codable {
    let searchTitle: String?
    let searchAuthorFirstName: String?
    let searchAuthorLastName: String?
    let searchGenres: [String]?
    let searchThemes: [String]?
    let searchDemographics: [String]?
    let searchContains: Bool
}
