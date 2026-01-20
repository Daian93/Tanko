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
