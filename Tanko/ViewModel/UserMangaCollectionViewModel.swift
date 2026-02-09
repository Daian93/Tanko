//
//  UserMangaCollectionViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 5/2/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
final class UserMangaCollectionViewModel {
    private var modelContext: ModelContext?

    func setModelContext(_ context: ModelContext) {
        modelContext = context
    }

    func addToCollection(
        manga: Manga,
        volumesOwned: [Int] = [],
        readingVolume: Int? = nil,
        completeCollection: Bool = false
    ) {
        guard let context = modelContext else { return }

        if isInCollection(mangaID: manga.id) {
            print("El manga ya está en la colección")
            return
        }

        let userManga = UserManga(
            mangaID: manga.id,
            title: manga.title,
            coverURL: manga.mainPicture,
            totalVolumes: manga.volumes,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )

        context.insert(userManga)
        try? context.save()
    }

    func removeFromCollection(userMangaID: UUID) {
        guard let context = modelContext else { return }

        let fetch = FetchDescriptor<UserManga>(
            predicate: #Predicate { $0.id == userMangaID }
        )

        if let userManga = (try? context.fetch(fetch))?.first {
            context.delete(userManga)
            try? context.save()
        }
    }

    func isInCollection(mangaID: Int) -> Bool {
        guard let context = modelContext else { return false }

        let fetch = FetchDescriptor<UserManga>(
            predicate: #Predicate { $0.mangaID == mangaID }
        )

        let count = (try? context.fetchCount(fetch)) ?? 0
        return count > 0
    }

    func userCollectionCount() -> Int {
        guard let context = modelContext else { return 0 }
        let fetch = FetchDescriptor<UserManga>()
        return (try? context.fetchCount(fetch)) ?? 0
    }

    var mangas: [UserManga] {
        guard let context = modelContext else { return [] }
        let fetch = FetchDescriptor<UserManga>()
        return (try? context.fetch(fetch)) ?? []
    }

    func updateVolumes(userMangaID: UUID, volumesOwned: [Int]) {
        guard let context = modelContext else { return }

        let fetch = FetchDescriptor<UserManga>(
            predicate: #Predicate { $0.id == userMangaID }
        )

        if let userManga = (try? context.fetch(fetch))?.first {
            userManga.volumesOwned = volumesOwned
            try? context.save()
        }
    }

    func updateReadingVolume(userMangaID: UUID, readingVolume: Int?) {
        guard let context = modelContext else { return }

        let fetch = FetchDescriptor<UserManga>(
            predicate: #Predicate { $0.id == userMangaID }
        )

        if let userManga = (try? context.fetch(fetch))?.first {
            userManga.readingVolume = readingVolume
            try? context.save()
        }
    }

    func updateCompleteStatus(userMangaID: UUID, completeCollection: Bool) {
        guard let context = modelContext else { return }

        let fetch = FetchDescriptor<UserManga>(
            predicate: #Predicate { $0.id == userMangaID }
        )

        if let userManga = (try? context.fetch(fetch))?.first {
            userManga.completeCollection = completeCollection
            try? context.save()
        }
    }
}
