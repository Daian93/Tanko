//
//  URL+List.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension URL {
    static func mangas(
        page: Int = NetworkConstants.defaultPage,
        perPage: Int = NetworkConstants.defaultPerPage
    ) -> URL {
        api
            .appending(path: "list/mangas")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(perPage)"),
            ])
    }

    static func bestMangas(
        page: Int = NetworkConstants.defaultPage,
        perPage: Int = NetworkConstants.defaultPerPage
    ) -> URL {
        api
            .appending(path: "list/bestMangas")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(perPage)"),
            ])
    }

    static let genres = api.appending(path: "list/genres")

    static let themes = api.appending(path: "list/themes")

    static let demographics = api.appending(path: "list/demographics")

    static func authors(
        page: Int = NetworkConstants.defaultPage,
        perPage: Int = NetworkConstants.defaultPerPage
    ) -> URL {
        api
            .appending(path: "list/authorsPaged")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(perPage)"),
            ])
    }

    static func mangaByGenre(_ genre: String) -> URL {
        api.appending(path: "list/mangaByGenre").appending(path: genre)
    }

    static func mangaByTheme(_ theme: String) -> URL {
        api.appending(path: "list/mangaByTheme").appending(path: theme)
    }

    static func mangaByDemographic(_ demographic: String) -> URL {
        api.appending(path: "list/mangaByDemographic").appending(
            path: demographic
        )
    }

    static func mangaByAuthor(
        id: String,
        page: Int = NetworkConstants.defaultPage,
        perPage: Int = NetworkConstants.defaultPerPage
    ) -> URL {
        api
            .appending(path: "list/mangaByAuthor")
            .appending(path: id)
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(perPage)")
            ])
    }

    static let authorsByIds = api.appending(path: "list/authorsByIds")
}
