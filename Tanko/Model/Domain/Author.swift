//
//  Author.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation
import SwiftUI

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
    var localizedKey: String {
        switch self {
        case .art: return "author.role.art"
        case .storyAndArt: return "author.role.storyAndArt"
        case .story: return "author.role.story"
        case .none: return "author.role.none"
        }
    }

    var localized: LocalizedStringKey {
        LocalizedStringKey(localizedKey)
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
