//
//  NetworkTest.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import Foundation

struct NetworkTest: NetworkRepository {
    func createUser(email: String, password: String) async throws(NetworkError) {}

    func login(email: String, password: String) async throws(NetworkError) -> String {
        "TEST_TOKEN"
    }

    func renew(token: String) async throws(NetworkError) -> String {
        "TEST_TOKEN"
    }

    func getMangas(page: Int, per: Int) async throws(NetworkError) -> Page<Manga> {
        Page(metadata: .init(total: 1, page: page, per: per), items: [.test])
    }

    func getBestMangas(page: Int, per: Int) async throws(NetworkError) -> Page<Manga> {
        Page(metadata: .init(total: 1, page: page, per: per), items: [.test])
    }
    
    func getManga(id: Int) async throws(NetworkError) -> Manga {
        .test
    }
    
    func getAuthors(page: Int, per: Int) async throws(NetworkError) -> Page<Author> {
        .init(metadata: .init(total: 1, page: page, per: per), items: [.test])
    }

    func getGenres() async throws(NetworkError) -> [Genre] {
        [.drama, .mystery]
    }

    func getThemes() async throws(NetworkError) -> [Theme] {
        [.psychological]
    }

    func getDemographics() async throws(NetworkError) -> [Demographic] {
        [.seinen]
    }

    func getMangasByGenre(
        genre: Genre,
        page: Int,
        per: Int
    ) async throws(NetworkError) -> Page<Manga> {
        try await getMangas(page: page, per: per)
    }

    func getMangasByTheme(
        theme: Theme,
        page: Int,
        per: Int
    ) async throws(NetworkError) -> Page<Manga> {
        try await getMangas(page: page, per: per)
    }

    func getMangasByDemographic(
        demographic: Demographic,
        page: Int,
        per: Int
    ) async throws(NetworkError) -> Page<Manga> {
        try await getMangas(page: page, per: per)
    }
    
    func getMangasByAuthor(_ authorId: String, page: Int, per: Int) async throws(NetworkError) -> Page<Manga> {
        Page(metadata: .init(total: 1, page: page, per: per), items: [.test])
    }
    
    func getAuthorsByIds(ids: [String]) async throws(NetworkError) -> [Author] {
        Author.tests
    }

    func advancedSearch(
        _ search: CustomSearchDTO,
        page: Int,
        per: Int
    ) async throws(NetworkError) -> Page<Manga> {
        try await getMangas(page: page, per: per)
    }

    func deleteMangaFromCollection(
        mangaId: String,
        token: String
    ) async throws(NetworkError) {}
}
