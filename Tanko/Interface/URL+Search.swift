//
//  URL+Search.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension URL {
    static func mangasContains(
        _ search: String,
        page: Int = NetworkConstants.defaultPage,
        perPage: Int = NetworkConstants.defaultPerPage
    ) -> URL {
        api
            .appending(path: "search/mangasContains").appending(path: search)
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(perPage)"),
            ])
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

    static func advancedMangaSearch(
        page: Int = NetworkConstants.defaultPage,
        perPage: Int = NetworkConstants.defaultPerPage
    ) -> URL {
        api
            .appending(path: "search/manga")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(perPage)"),
            ])
    }

}
