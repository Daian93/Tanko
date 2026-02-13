//
//  RemoteMangaCollectionRepository.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation
import SwiftData

@MainActor
final class RemoteMangaCollectionRepository: MangaCollectionRepository {

    private let network: NetworkRepository & NetworkInteractor
    private let session: SessionManager
    private let localRepo: LocalMangaCollectionRepository

    init(
        network: NetworkRepository & NetworkInteractor,
        session: SessionManager,
        localRepo: LocalMangaCollectionRepository
    ) {
        self.network = network
        self.session = session
        self.localRepo = localRepo
    }

    // MARK: - Obtener colección remota y mapear a local
    func getCollection() async throws -> [MangaSyncData] {
        guard let token = session.token else { return [] }
        let request = URLRequest.get(url: .collectionManga, bearerToken: token)
        let response = try await network.getJSON(
            request,
            type: [UserMangaCollectionDTO].self
        )

        return response.map { dto in
            MangaSyncData(
                mangaID: dto.manga.id,
                title: dto.manga.title,
                coverURL: dto.manga.mainPicture?.asURL,
                totalVolumes: dto.manga.volumes,
                volumesOwned: Array(dto.volumesOwned),
                readingVolume: dto.readingVolume,
                completeCollection: dto.completeCollection,
                updatedAt: .now
            )
        }
    }

    func updateOrCreate(with remote: MangaSyncData) async throws {
        try await add(mangaData: remote)
    }

    func getMangaFromCollection(mangaID: Int) async throws
        -> UserMangaCollectionDTO
    {
        guard let token = session.token else {
            throw NetworkError.unauthorized
        }

        var request = URLRequest.get(url: .collectionMangaID(mangaID))
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return try await network.getJSON(
            request,
            type: UserMangaCollectionDTO.self
        )
    }

    // MARK: - Añadir manga a colección remota y local
    func add(mangaData: MangaSyncData) async throws {
        guard let token = session.token else { return }

        let requestDTO = UserMangaCollectionRequest(
            manga: mangaData.mangaID,
            volumesOwned: mangaData.volumesOwned,
            readingVolume: mangaData.readingVolume,
            completeCollection: mangaData.completeCollection
        )

        let request = URLRequest.post(
            url: .collectionManga,
            body: requestDTO,
            bearerToken: token
        )

        try await network.postJSON(request, status: 200)
    }

    // MARK: - Eliminar manga de colección remota y local
    func remove(_ manga: UserManga) async throws {
        guard let token = session.token else { return }

        let request = URLRequest.delete(
            url: .collectionMangaID(manga.mangaID),
            bearerToken: token
        )
        try await network.deleteJSON(request)

        try await localRepo.remove(manga)
    }
}
