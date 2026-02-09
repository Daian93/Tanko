//
//  Network.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import Foundation

struct Network: NetworkRepository {

    // MARK: - Auth
    func createUser(email: String, password: String) async throws(NetworkError) {
        let body = UsersCreate(email: email, password: password)
        _ = try await postJSON(
            .post(url: .createUser, body: body),
            type: UserResponse.self
        )
    }

    func login(email: String, password: String) async throws(NetworkError) -> String {
        let login = UsersCreate(email: email, password: password)
        let response = try await postJSON(
            .post(url: .login, body: login),
            type: TokenResponse.self
        )
        return response.token
    }

    func renew(token: String) async throws(NetworkError) -> String {
        let response = try await postJSON(
            .post(url: .renew, bearerToken: token),
            type: TokenResponse.self
        )
        return response.token
    }

    // MARK: - Manga list
    func getMangas(
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    )
        async throws(NetworkError) -> Page<Manga>
    {
        try await getJSON(
            .get(url: .mangas(page: page, perPage: per)),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }

    func getBestMangas(
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {
        try await getJSON(
            .get(url: .bestMangas(page:page, perPage: per)),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }
    
    func getManga(id: Int) async throws(NetworkError) -> Manga {
        try await getJSON(
            .get(url: .manga(id: id)),
            type: MangaDTO.self
        ).toManga
    }

    // MARK: - Filters

    func getGenres() async throws(NetworkError) -> [Genre] {
        try await getJSON(
            .get(url: .genres),
            type: [GenreDTO].self
        ).compactMap(\.genreType)
    }

    func getThemes() async throws(NetworkError) -> [Theme] {
        try await getJSON(
            .get(url: .themes),
            type: [ThemeDTO].self
        ).compactMap(\.themeType)
    }

    func getDemographics() async throws(NetworkError) -> [Demographic] {
        try await getJSON(
            .get(url: .demographics),
            type: [DemographicDTO].self
        ).compactMap(\.demographicType)
    }
    
    func getAuthors(
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Author> {
        try await getJSON(
            .get(url: .authors(page: page, perPage: per)),
            type: MangaPageDTO<AuthorDTO>.self
        ).toAuthorPage
    }

    func getMangasByGenre(
        genre: Genre,
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {
        try await getJSON(
            .get(url: .mangaByGenre(genre.rawValue)),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }

    func getMangasByTheme(
        theme: Theme,
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {
        try await getJSON(
            .get(url: .mangaByTheme(theme.rawValue)),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }

    func getMangasByDemographic(
        demographic: Demographic,
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {
        try await getJSON(
            .get(url: .mangaByDemographic(demographic.rawValue)),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }
    
    func getMangasByAuthor(
        _ authorId: String,
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {
        try await getJSON(
            .get(url: .mangaByAuthor(id: authorId, page: page, perPage: per)),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }
    
    func getAuthorsByIds(ids: [String]) async throws(NetworkError) -> [Author] {
        try await postJSON(.post(url: .authorsByIds, body: ids), type: [AuthorDTO].self).map(\.toAuthor)
    }

    // MARK: - Search

    func advancedSearch(
        _ search: CustomSearchDTO,
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {
        try await postJSON(
            .post(url: .advancedMangaSearch, body: search),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }

    func searchMangasBeginsWith(_ search: String) async throws(NetworkError) -> [Manga] {
        try await getJSON(
            .get(url: .mangasBeginsWith(search)),
            type: [MangaDTO].self
        ).map(\.toManga)
    }

    func searchMangasContains(_ search: String) async throws(NetworkError) -> [Manga] {
        try await getJSON(
            .get(url: .mangasContains(search)),
            type: [MangaDTO].self
        ).map(\.toManga)
    }

    // MARK: - Collection

    func deleteMangaFromCollection(mangaId: String, token: String) async throws(NetworkError) {
        try await postJSON(
            .delete(
                url: .collectionManga(id: mangaId),
                bearerToken: token
            ),
            status: 204
        )
    }
}

