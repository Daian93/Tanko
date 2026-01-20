//
//  URL+Collection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension URL {
    static let collectionManga = api.appending(path: "collection/manga")

    static func collectionManga(id: String) -> URL {
        api.appending(path: "collection/manga").appending(path: id)
    }
}
