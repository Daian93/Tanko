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

extension GenreDTO {
    static let test = GenreDTO(
        id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!,
        genre: "Drama"
    )
}
