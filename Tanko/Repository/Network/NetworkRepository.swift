//
//  NetworkRepository.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    
    // MARK: - Auth
    func createUser(email: String, password: String) async throws
    func login(email: String, password: String) async throws -> String
    func renew(token: String) async throws(NetworkError) -> String
    
    // MARK: - Manga list
    func getMangas(page: Int, per: Int) async throws(NetworkError) -> Page<Manga>
    func getBestMangas(page: Int, per: Int) async throws(NetworkError) -> Page<Manga>
    func getManga(id: Int) async throws(NetworkError) -> Manga
    
    // MARK: - Filters
    func getGenres() async throws(NetworkError) -> [Genre]
    func getThemes() async throws(NetworkError) -> [Theme]
    func getDemographics() async throws(NetworkError) -> [Demographic]
    func getAuthors(page: Int, per: Int) async throws(NetworkError) -> Page<Author>
    
    func getMangasByGenre(genre: Genre, page: Int, per: Int)
    async throws(NetworkError) -> Page<Manga>
    func getMangasByTheme(theme: Theme, page: Int, per: Int)
    async throws(NetworkError) -> Page<Manga>
    func getMangasByDemographic(demographic: Demographic, page: Int, per: Int)
    async throws(NetworkError) -> Page<Manga>
    func getMangasByAuthor(_ authorId: String, page: Int, per: Int)
    async throws(NetworkError) -> Page<Manga>
    func getAuthorsByIds(ids: [String]) async throws(NetworkError) -> [Author]
    
    // MARK: - Search
    func advancedSearch(_ search: CustomSearchDTO, page: Int, per: Int) async throws(NetworkError) -> Page<Manga>
    func searchMangasBeginsWith(_ search: String) async throws(NetworkError) -> [Manga]
    func searchMangasContains(_ search: String, page: Int, per: Int) async throws(NetworkError) -> Page<Manga>
    
    // MARK: - Collection
    func getUserCollection(token: String) async throws -> [UserMangaCollectionDTO]
    func addUserMangaToCollection(_ manga: UserMangaCollectionRequest, token: String) async throws
    func removeUserMangaFromCollection(mangaID: Int, token: String) async throws
    func getMangaFromCollection(mangaID: Int, token: String) async throws -> UserMangaCollectionDTO
}
