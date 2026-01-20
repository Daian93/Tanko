//
//  URL+Search.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension URL {
    static func mangasContains(_ search: String) -> URL {
        api.appending(path: "search/mangasContains").appending(path: search)
    }

    static func mangasBeginsWith(_ search: String) -> URL {
        api.appending(path: "search/mangasBeginsWith").appending(path: search)
    }

    static func author(_ search: String) -> URL {
        api.appending(path: "search/author").appending(path: search)
    }

    static func manga(id: Int) -> URL {
        api.appending(path: "search/manga").appending(path: "\(id)")
    }

    static let advancedMangaSearch = api.appending(path: "search/manga")
}
