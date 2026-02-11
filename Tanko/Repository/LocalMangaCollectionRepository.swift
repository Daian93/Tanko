//
//  LocalMangaCollectionRepository.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftData
import SwiftUI

@MainActor
final class LocalMangaCollectionRepository: MangaCollectionRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getCollection() async throws -> [MangaSyncData] {
        let descriptor = FetchDescriptor<UserManga>()
        let items = try context.fetch(descriptor)
        return items.map { manga in
            MangaSyncData(
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

    func updateOrCreate(with remote: MangaSyncData) async throws {
        let id = remote.mangaID
        let fetch = FetchDescriptor<UserManga>(predicate: #Predicate { $0.mangaID == id })
        
        if let existing = try context.fetch(fetch).first {
            existing.volumesOwned = remote.volumesOwned
            existing.readingVolume = remote.readingVolume
            existing.completeCollection = remote.completeCollection
            existing.updatedAt = remote.updatedAt
        } else {
            let newManga = UserManga(
                mangaID: remote.mangaID,
                title: remote.title,
                coverURL: remote.coverURL,
                volumesOwned: remote.volumesOwned,
                readingVolume: remote.readingVolume,
                completeCollection: remote.completeCollection,
                updatedAt: remote.updatedAt
            )
            context.insert(newManga)
        }
        try context.save()
    }

    func add(mangaData: MangaSyncData) async throws {
        try await updateOrCreate(with: mangaData)
    }

    func remove(_ manga: UserManga) async throws {
        _ = manga.id
        context.delete(manga)
        try context.save()
    }
}
