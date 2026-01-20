//
//  Enums.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

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

extension Genre: Identifiable {
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .action: return "Acción"
        case .adventure: return "Aventura"
        case .awardWinning: return "Premiado"
        case .drama: return "Drama"
        case .fantasy: return "Fantasía"
        case .horror: return "Terror"
        case .supernatural: return "Sobrenatural"
        case .mystery: return "Misterio"
        case .sliceOfLife: return "Recuentos de la vida"
        case .comedy: return "Comedia"
        case .sciFi: return "Ciencia ficción"
        case .suspense: return "Suspenso"
        case .sports: return "Deportes"
        case .ecchi: return "Ecchi"
        case .romance: return "Romance"
        case .girlsLove: return "Amor entre chicas"
        case .boysLove: return "Amor entre chicos"
        case .gourmet: return "Gastronomía"
        case .erotica: return "Erótico"
        case .hentai: return "Hentai"
        case .avantGarde: return "Vanguardia"
        }
    }
}

enum Demographic: String, Codable, CaseIterable {
    case seinen = "Seinen"
    case shounen = "Shounen"
    case shoujo = "Shoujo"
    case josei = "Josei"
    case kids = "Kids"
}

extension Demographic: Identifiable {
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .seinen: return "Seinen"
        case .shounen: return "Shōnen"
        case .shoujo: return "Shōjo"
        case .josei: return "Josei"
        case .kids: return "Infantil"
        }
    }
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

extension Theme: Identifiable {
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .gore: return "Gore"
        case .military: return "Militar"
        case .mythology: return "Mitología"
        case .psychological: return "Psicológico"
        case .historical: return "Histórico"
        case .samurai: return "Samurái"
        case .romanticSubtext: return "Subtexto romántico"
        case .school: return "Escolar"
        case .adultCast: return "Reparto adulto"
        case .parody: return "Parodia"
        case .superPower: return "Superpoderes"
        case .teamSports: return "Deportes de equipo"
        case .delinquents: return "Delincuentes"
        case .workplace: return "Entorno laboral"
        case .survival: return "Supervivencia"
        case .childcare: return "Crianza"
        case .iyashikei: return "Iyashikei"
        case .reincarnation: return "Reencarnación"
        case .showbiz: return "Espectáculo"
        case .anthropomorphic: return "Antropomórfico"
        case .lovePolygon: return "Polígono amoroso"
        case .music: return "Música"
        case .mecha: return "Mecha"
        case .combatSports: return "Deportes de combate"
        case .isekai: return "Isekai"
        case .gagHumor: return "Humor absurdo"
        case .crossdressing: return "Travestismo"
        case .reverseHarem: return "Harem inverso"
        case .martialArts: return "Artes marciales"
        case .visualArts: return "Artes visuales"
        case .harem: return "Harem"
        case .otakuCulture: return "Cultura otaku"
        case .timeTravel: return "Viajes en el tiempo"
        case .videoGame: return "Videojuegos"
        case .strategyGame: return "Juegos de estrategia"
        case .vampire: return "Vampiros"
        case .mahouShoujo: return "Mahō Shōjo"
        case .highStakesGame: return "Juegos de alto riesgo"
        case .cgdct: return "CGDCT"
        case .organizedCrime: return "Crimen organizado"
        case .detective: return "Detectives"
        case .performingArts: return "Artes escénicas"
        case .medical: return "Médico"
        case .space: return "Espacio"
        case .memoir: return "Memorias"
        case .villainess: return "Villana"
        case .racing: return "Carreras"
        case .pets: return "Mascotas"
        case .magicalSexShift: return "Cambio mágico de sexo"
        case .educational: return "Educativo"
        case .idolsFemale: return "Idols (femeninas)"
        case .idolsMale: return "Idols (masculinos)"
        }
    }
}
