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
