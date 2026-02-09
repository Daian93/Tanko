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

    func getCollection() async throws -> [UserManga] {
        let descriptor = FetchDescriptor<UserManga>()
        return try context.fetch(descriptor)
    }

    func add(_ manga: UserManga) async throws {
        let id = manga.id
        let fetch = FetchDescriptor<UserManga>(
            predicate: #Predicate<UserManga> { $0.id == id }
        )
        if try context.fetch(fetch).first != nil { return }

        context.insert(manga)
        try context.save()
    }

    func remove(_ manga: UserManga) async throws {
        let id = manga.id
        let fetch = FetchDescriptor<UserManga>(predicate: #Predicate<UserManga> { $0.id == id })
        if let existing = try context.fetch(fetch).first {
            context.delete(existing)
            try context.save()
        }
    }
}

