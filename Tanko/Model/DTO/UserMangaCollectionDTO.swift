//
//  UserMangaCollectionDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

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

extension UserMangaCollectionDTO {
    var toDomain: UserMangaCollection {
        UserMangaCollection(
            id: id,
            manga: manga.toManga,
            volumesOwned: Set(volumesOwned),
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )
    }
}
