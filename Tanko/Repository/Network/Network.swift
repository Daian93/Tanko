//
//  Network.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import Foundation

struct EmptyResponse: Codable {}

struct Network: NetworkRepository {

    private let appToken = "sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY"

    // MARK: - Auth
    func createUser(email: String, password: String) async throws {
        guard await AuthValidator.isValidEmail(email) else {
            throw AuthError.invalidEmail
        }

        guard await AuthValidator.isValidPassword(password) else {
            throw AuthError.weakPassword
        }

        let body = UsersCreate(email: email, password: password)
        var request = URLRequest.post(url: .createUser, body: body)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(appToken, forHTTPHeaderField: "App-Token")

        try await postJSON(request, status: 201)
    }

    func login(email: String, password: String) async throws
        -> String
    {
        guard await AuthValidator.isValidEmail(email) else {
            throw AuthError.invalidEmail
        }

        guard await AuthValidator.isValidPassword(password) else {
            throw AuthError.weakPassword
        }

        let credentials = "\(email):\(password)"
        guard let data = credentials.data(using: .utf8) else {
            throw NetworkError.invalidData
        }

        let encoded = data.base64EncodedString()

        var request = URLRequest(url: .jwtLogin)
        request.httpMethod = "POST"

        request.setValue(
            "Basic \(encoded)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(appToken, forHTTPHeaderField: "App-Token")

        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let response = try await postJSON(request, type: JWTTokenResponse.self)
        return response.token
    }

    func renew(token: String) async throws(NetworkError) -> String {
        let request = authRequest(url: .renew, method: "POST", token: token)
        let response = try await postJSON(request, type: JWTTokenResponse.self)
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
            .get(url: .bestMangas(page: page, perPage: per)),
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
        try await postJSON(
            .post(url: .authorsByIds, body: ids),
            type: [AuthorDTO].self
        ).map(\.toAuthor)
    }

    // MARK: - Search

    func advancedSearch(
        _ search: CustomSearchDTO,
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {

        let url = URL.advancedMangaSearch(page: page, perPage: per)

        return try await postJSON(
            .post(url: url, body: search),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }

    func searchMangasBeginsWith(_ search: String) async throws(NetworkError)
        -> [Manga]
    {
        try await getJSON(
            .get(url: .mangasBeginsWith(search)),
            type: [MangaDTO].self
        ).map(\.toManga)
    }

    func searchMangasContains(
        _ search: String,
        page: Int = NetworkConstants.defaultPage,
        per: Int = NetworkConstants.defaultPerPage
    ) async throws(NetworkError) -> Page<Manga> {
        let url = URL.mangasContains(search, page: page, perPage: per)

        return try await getJSON(
            .get(url: url),
            type: MangaPageDTO<MangaDTO>.self
        ).toMangaPage
    }

    func getUserCollection(token: String) async throws
        -> [UserMangaCollectionDTO]
    {
        var request = URLRequest.get(url: .collectionManga)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return try await getJSON(request, type: [UserMangaCollectionDTO].self)
    }

    func addUserMangaToCollection(
        _ manga: UserMangaCollectionRequest,
        token: String
    ) async throws {
        var request = URLRequest.post(url: .collectionManga, body: manga)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        _ = try await postJSON(request, type: EmptyResponse.self)
    }

    func removeUserMangaFromCollection(mangaID: Int, token: String) async throws
    {
        var request = URLRequest.delete(url: .collectionMangaID(mangaID))
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        _ = try await deleteJSON(request)
    }

    func getMangaFromCollection(mangaID: Int, token: String) async throws
        -> UserMangaCollectionDTO
    {
        var request = URLRequest.get(url: .collectionMangaID(mangaID))
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return try await getJSON(request, type: UserMangaCollectionDTO.self)
    }

    // MARK: - Private Helper
    
    private func authRequest(url: URL, method: String, token: String)
        -> URLRequest
    {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
