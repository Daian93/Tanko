//
//  Model.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import Foundation

// MARK: - Domain Enums

enum Genre: String, Codable, CaseIterable {
    case action = "Action"
    case adventure = "Adventure"
    case awardWinning = "Award Winning"
    case drama = "Drama"
    case fantasy = "Fantasy"
    case horror = "Horror"
    case supernatural = "Supernatural"
    case mystery = "Mystery"
    case sliceOfLife = "Slice of Life"
    case comedy = "Comedy"
    case sciFi = "Sci-Fi"
    case suspense = "Suspense"
    case sports = "Sports"
    case ecchi = "Ecchi"
    case romance = "Romance"
    case girlsLove = "Girls Love"
    case boysLove = "Boys Love"
    case gourmet = "Gourmet"
    case erotica = "Erotica"
    case hentai = "Hentai"
    case avantGarde = "Avant Garde"
}

enum Demographic: String, Codable, CaseIterable {
    case seinen = "Seinen"
    case shounen = "Shounen"
    case shoujo = "Shoujo"
    case josei = "Josei"
    case kids = "Kids"
}

enum Theme: String, Codable, CaseIterable {
    case gore = "Gore"
    case military = "Military"
    case mythology = "Mythology"
    case psychological = "Psychological"
    case historical = "Historical"
    case samurai = "Samurai"
    case romanticSubtext = "Romantic Subtext"
    case school = "School"
    case adultCast = "Adult Cast"
    case parody = "Parody"
    case superPower = "Super Power"
    case teamSports = "Team Sports"
    case delinquents = "Delinquents"
    case workplace = "Workplace"
    case survival = "Survival"
    case childcare = "Childcare"
    case iyashikei = "Iyashikei"
    case reincarnation = "Reincarnation"
    case showbiz = "Showbiz"
    case anthropomorphic = "Anthropomorphic"
    case lovePolygon = "Love Polygon"
    case music = "Music"
    case mecha = "Mecha"
    case combatSports = "Combat Sports"
    case isekai = "Isekai"
    case gagHumor = "Gag Humor"
    case crossdressing = "Crossdressing"
    case reverseHarem = "Reverse Harem"
    case martialArts = "Martial Arts"
    case visualArts = "Visual Arts"
    case harem = "Harem"
    case otakuCulture = "Otaku Culture"
    case timeTravel = "Time Travel"
    case videoGame = "Video Game"
    case strategyGame = "Strategy Game"
    case vampire = "Vampire"
    case mahouShoujo = "Mahou Shoujo"
    case highStakesGame = "High Stakes Game"
    case cgdct = "CGDCT"
    case organizedCrime = "Organized Crime"
    case detective = "Detective"
    case performingArts = "Performing Arts"
    case medical = "Medical"
    case space = "Space"
    case memoir = "Memoir"
    case villainess = "Villainess"
    case racing = "Racing"
    case pets = "Pets"
    case magicalSexShift = "Magical Sex Shift"
    case educational = "Educational"
    case idolsFemale = "Idols (Female)"
    case idolsMale = "Idols (Male)"
}

// MARK: - Domain Models

struct Manga: Identifiable {
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

struct Author: Identifiable {
    let id: UUID
    let fullName: String
    let role: AuthorRole
}

// MARK: - Helper Extensions

extension String {
    var cleanedURL: String {
        self.replacingOccurrences(of: "\\", with: "")
            .replacingOccurrences(of: "\"", with: "")
    }
    
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}

