//
//  Author.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct Author: Identifiable, Hashable, Codable {
    let id: UUID
    let fullName: String
    let role: AuthorRole
}

enum AuthorRole: String, Codable, CaseIterable {
    case art = "Art"
    case storyAndArt = "Story & Art"
    case story = "Story"
    case none = "None"
}

extension AuthorRole {
    var displayName: String {
        switch self {
        case .art: return "Artista"
        case .storyAndArt: return "Escritor y artista"
        case .story: return "Escritor"
        case .none: return "Desconocido"
        }
    }

    var icon: String {
        switch self {
        case .art: return "paintbrush.fill"
        case .storyAndArt: return "person.2.fill"
        case .story: return "pencil"
        case .none: return "person.fill.questionmark"
        }
    }
}

extension Author {
    static let test = Author(
        id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!,
        fullName: "Naoki Urasawa",
        role: .storyAndArt
    )

    static let tests: [Author] = [
        Author(
            id: UUID(uuidString: "00003F96-C82D-451F-A63C-356FB29550BC")!,
            fullName: "Shirou Toozaki",
            role: .story
        ),
        Author(
            id: UUID(uuidString: "00047D82-9599-4F05-A782-F157A49CAE07")!,
            fullName: "Kousaku Anakubo",
            role: .storyAndArt
        ),
    ]
}
