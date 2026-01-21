//
//  PageDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct MangaPageDTO<T: Codable>: Codable {
    let metadata: PageMetadataDTO
    let items: [T]
}

struct PageMetadataDTO: Codable {
    let total: Int
    let per: Int
    let page: Int
}

extension MangaPageDTO where T == MangaDTO {
    var toMangaPage: Page<Manga> {
        Page(
            metadata: metadata.toPageMetadata,
            items: items.map(\.toManga) 
        )
    }
}

extension MangaPageDTO where T == AuthorDTO {
    var toAuthorPage: Page<Author> {
        Page(
            metadata: metadata.toPageMetadata,
            items: items.map(\.toAuthor)
        )
    }
}

extension PageMetadataDTO {
    var toPageMetadata: PageMetadata {
        PageMetadata(
            total: total,
            page: page,
            per: per
        )
    }
}
