//
//  AuthorDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct AuthorDTO: Codable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let role: AuthorRole
}

extension AuthorDTO {
    var toAuthor: Author {
        Author(
            id: id,
            fullName: "\(firstName) \(lastName)",
            role: role
        )
    }
}

extension AuthorDTO {
    static let test = AuthorDTO(
        id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!,
        firstName: "Naoki",
        lastName: "Urasawa",
        role: .storyAndArt
    )
}
