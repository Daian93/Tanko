//
//  MangaCollectionSyncService.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 10/2/26.
//

import Foundation
import SwiftData

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

            case let (local?, remote?):
                if local.updatedAt > remote.updatedAt {
                    try await remoteRepo.add(mangaData: local)
                } else if remote.updatedAt > local.updatedAt {
                    try await localRepo.updateOrCreate(with: remote)
                }

            case let (local?, nil):
                try await remoteRepo.add(mangaData: local)

            case let (nil, remote?):
                try await localRepo.updateOrCreate(with: remote)

            default:
                break
            }
        }
    }

    private func extractSyncData(from manga: UserManga) -> MangaSyncData {
        return MangaSyncData(
            mangaID: manga.mangaID,
            title: manga.title,
            coverURL: manga.coverURL,
            volumesOwned: manga.volumesOwned,
            readingVolume: manga.readingVolume,
            completeCollection: manga.completeCollection,
            updatedAt: manga.updatedAt
        )
    }
}

struct MangaSyncData {
    let mangaID: Int
    let title: String
    let coverURL: URL?
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
    let updatedAt: Date
}
