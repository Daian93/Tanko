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
