//
//  GenreDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct GenreDTO: Codable, Identifiable {
    let id: UUID
    let genre: String
}

extension GenreDTO {
    var genreType: Genre? {
        Genre(
            rawValue: genre
        )
    }
}
