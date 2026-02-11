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
    
    var mangas: [UserManga] = []
    private let syncService: MangaCollectionSyncService

    init(
        context: ModelContext,
        repository: MangaCollectionRepository,
        syncService: MangaCollectionSyncService
    ) {
        self.modelContext = context
        self.repository = repository
        self.syncService = syncService
    }
    
    func synchronize() async {
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
            _ = try await repository.getCollection()
            
            let descriptor = FetchDescriptor<UserManga>(
                sortBy: [SortDescriptor(\UserManga.title)]
            )
            
            self.mangas = try modelContext.fetch(descriptor)
            
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
        
        let syncData = MangaSyncData(
            mangaID: newUserManga.mangaID,
            title: newUserManga.title,
            coverURL: newUserManga.coverURL,
            volumesOwned: newUserManga.volumesOwned,
            readingVolume: newUserManga.readingVolume,
            completeCollection: newUserManga.completeCollection,
            updatedAt: newUserManga.updatedAt
        )
        
        try? await repository.add(mangaData: syncData)
    }

    func remove(_ manga: UserManga) async {
        let idToRemove = manga.mangaID
        
        try? await repository.remove(manga)
        
        modelContext.delete(manga)
        self.mangas.removeAll { $0.mangaID == idToRemove }
        
        try? modelContext.save()
    }

    func isInCollection(mangaID: Int) -> Bool {
        mangas.contains(where: { $0.mangaID == mangaID })
    }

    func removeFromCollection(mangaID: Int) async {
        if let manga = mangas.first(where: { $0.mangaID == mangaID }) {
            await remove(manga)
        }
    }
    
    func updateRemote(_ userManga: UserManga) async {
        let syncData = userManga.asSyncData
        do {
            try await repository.add(mangaData: syncData)
            print("✅ Sincronizado con el servidor")
        } catch {
            print("❌ Error al sincronizar: \(error)")
        }
    }
}
