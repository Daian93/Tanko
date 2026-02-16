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
    private let modelContext: ModelContext
    private let repository: MangaCollectionRepository
    
    var mangas: [UserManga] = []
    private var isSyncing = false
    private var isLoading = false
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
        guard !isSyncing else {
            print("⚠️ Sincronización ya en progreso")
            return
        }
        isSyncing = true
        
        defer { isSyncing = false }
        
        do {
            print("🔄 Iniciando sincronización...")
            try await syncService.sync()
            print("✅ Sincronización completada. Recargando datos...")
            await reloadFromLocalDatabase()
        } catch NetworkError.cancelled {
            print("⚠️ Synchronization cancelled")
        } catch NetworkError.invalidJSON {
            print("⚠️ Server returned OK but no valid JSON")
        } catch {
            print("❌ Error during synchronization: \(error)")
        }
    }
    
    func loadCollection() async {
        guard !isLoading else {
            print("⚠️ Carga ya en progreso")
            return
        }
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            _ = try await repository.getCollection()
            await reloadFromLocalDatabase()
            
        } catch NetworkError.cancelled {
            print("⚠️ Load cancelled")
        } catch {
            print("❌ Error loading collection: \(error)")
        }
    }
    
    // MARK: - Private helper to reload from local database
    private func reloadFromLocalDatabase() async {
        do {
            let descriptor = FetchDescriptor<UserManga>(
                sortBy: [SortDescriptor(\UserManga.title)]
            )
            
            self.mangas = try modelContext.fetch(descriptor)
            print("✅ Local collection updated: \(mangas.count) mangas")
            
            // Update widget after reloading
            updateWidget()
        } catch {
            print("❌ Error reloading from local database: \(error)")
        }
    }
    
    func add(
        manga: Manga,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async {
        let newUserManga = UserManga(
            mangaID: manga.id,
            title: manga.title,
            coverURL: manga.mainPicture,
            totalVolumes: manga.volumes,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection,
            updatedAt: .now
        )
        
        modelContext.insert(newUserManga)
        self.mangas.append(newUserManga)
        try? modelContext.save()
        updateWidget()
        
        let syncData = MangaSyncData(
            mangaID: newUserManga.mangaID,
            title: newUserManga.title,
            coverURL: newUserManga.coverURL,
            totalVolumes: newUserManga.totalVolumes,
            volumesOwned: newUserManga.volumesOwned,
            readingVolume: newUserManga.readingVolume,
            completeCollection: newUserManga.completeCollection,
            updatedAt: newUserManga.updatedAt
        )
        
        do {
            try await repository.add(mangaData: syncData)
            print("✅ Manga added to server")
        } catch {
            print("⚠️ Failed to add to server, saved locally: \(error)")
        }
    }
    
    func remove(_ manga: UserManga) async {
        let idToRemove = manga.mangaID
        
        try? await repository.remove(manga)
        
        modelContext.delete(manga)
        self.mangas.removeAll { $0.mangaID == idToRemove }
        
        try? modelContext.save()
        updateWidget()
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
            print("✅ Synced with server")
            updateWidget()
        } catch {
            print("⚠️ Failed to sync, data saved locally: \(error)")
        }
    }
    
    private func updateWidget() {
        let readingMangas: [ReadingManga] = mangas.compactMap { manga in
            // Solo incluir mangas que están siendo leídos
            guard let readingVolume = manga.readingVolume, readingVolume > 0 else {
                return nil
            }
            
            // Si tiene total de volúmenes, verificar que no esté completo
            if let total = manga.totalVolumes, readingVolume >= total {
                return nil
            }
            
            print("📚 Widget - Añadiendo manga: \(manga.title)")
            print("🖼️ Cover URL: \(manga.coverURL?.absoluteString ?? "nil")")
            
            return ReadingManga(
                id: manga.mangaID,
                title: manga.title,
                coverURL: manga.coverURL,
                readingVolume: readingVolume,
                totalVolumes: manga.totalVolumes
            )
        }
        
        print("📊 Total mangas para widget: \(readingMangas.count)")
        WidgetDataManager.shared.save(readingMangas)
    }
}
