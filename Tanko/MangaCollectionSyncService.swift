//
//  MangaCollectionSyncService.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 10/2/26.
//

@MainActor
final class MangaCollectionSyncService {

    private let localRepo: LocalMangaCollectionRepository
    private let remoteRepo: RemoteMangaCollectionRepository

    init(
        local: LocalMangaCollectionRepository,
        remote: RemoteMangaCollectionRepository
    ) {
        self.localRepo = local
        self.remoteRepo = remote
    }

    func sync() async throws {
        let localItems = try await localRepo.getCollection()
        let remoteItems = try await remoteRepo.getCollection()

        let localByID = Dictionary(uniqueKeysWithValues: localItems.map { ($0.mangaID, $0) })
        let remoteByID = Dictionary(uniqueKeysWithValues: remoteItems.map { ($0.mangaID, $0) })

        let allIDs = Set(localByID.keys).union(remoteByID.keys)

        for id in allIDs {
            switch (localByID[id], remoteByID[id]) {

            // 🔄 Existe en ambos → resolver conflicto por timestamp
            case let (localManga?, remoteManga?):
                if localManga.updatedAt > remoteManga.updatedAt {
                    try await remoteRepo.add(localManga)
                } else if remoteManga.updatedAt > localManga.updatedAt {
                    try await localRepo.add(remoteManga)
                }

            // ⬆️ Solo local → subir a remoto
            case let (localManga?, nil):
                try await remoteRepo.add(localManga)

            // ⬇️ Solo remoto → guardar en local
            case let (nil, remoteManga?):
                try await localRepo.add(remoteManga)

            default:
                break
            }
        }
    }
}
