//
//  UserMangaCollectionViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 5/2/26.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class UserMangaCollectionViewModel {
    private let modelContext: ModelContext
    private let repository: MangaCollectionRepository
    private let localRepo: LocalMangaCollectionRepository
    private let remoteRepo: RemoteMangaCollectionRepository?

    var mangas: [UserManga] = []
    private let syncService: MangaCollectionSyncService

        init(
            context: ModelContext,
            repository: MangaCollectionRepository,
            localRepo: LocalMangaCollectionRepository,
            remoteRepo: RemoteMangaCollectionRepository?,
            syncService: MangaCollectionSyncService
        ) {
            self.modelContext = context
            self.repository = repository
            self.localRepo = localRepo
            self.remoteRepo = remoteRepo
            self.syncService = syncService
        }
    
    func synchronize() async {
            guard remoteRepo != nil else { return }
            
            do {
                print("🔄 Iniciando sincronización...")
                try await syncService.sync()
                print("✅ Sincronización completada. Recargando datos...")
                await loadCollection()
            } catch {
                print("❌ Error durante la sincronización: \(error)")
            }
        }

    func loadCollection() async {
        do {
            let items = try await repository.getCollection()
            self.mangas = items
            
            let fetch = FetchDescriptor<UserManga>()
            let local = try modelContext.fetch(fetch)
            for m in local { modelContext.delete(m) }
            for m in items { modelContext.insert(m) }
            
            try modelContext.save()
        } catch {
            print("❌ Error cargando colección:", error)
        }
    }

    func add(manga: Manga, volumesOwned: [Int], readingVolume: Int?, completeCollection: Bool) async {
        let newUserManga = UserManga(
            mangaID: manga.id,
            title: manga.title,
            coverURL: manga.mainPicture,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection,
            updatedAt: .now
        )
        
        modelContext.insert(newUserManga)
        self.mangas.append(newUserManga)
        
        try? modelContext.save()
        try? await repository.add(newUserManga)
    }

    func remove(_ manga: UserManga) async {
        let idToRemove = manga.mangaID
        modelContext.delete(manga)
        self.mangas.removeAll { $0.mangaID == idToRemove }
        
        try? modelContext.save()
        try? await repository.remove(manga)
    }

    func isInCollection(mangaID: Int) -> Bool {
        mangas.contains(where: { $0.mangaID == mangaID })
    }

    func removeFromCollection(mangaID: Int) async {
        if let manga = mangas.first(where: { $0.mangaID == mangaID }) {
            await remove(manga)
        }
    }
}
