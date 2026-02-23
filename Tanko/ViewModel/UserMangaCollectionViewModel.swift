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
    
    let isAuthenticated: Bool
    let offlineManager: OfflineOperationsManager
    
    var isAddingManga: Bool = false
    var hasPendingOperations: Bool {
        isAuthenticated && offlineManager.pendingOperationsCount > 0
    }

    // MARK: - Collection Filter

    var selectedFilter: CollectionFilter = .todo

    enum CollectionFilter: String, CaseIterable {
        case todo        = "collection.filter.all"
        case porEmpezar  = "collection.filter.notStarted"
        case leyendo     = "collection.filter.reading"
        case leidos      = "collection.filter.read"
        case completados = "collection.filter.complete"
        
        var localized: LocalizedStringKey {
            LocalizedStringKey(self.rawValue)
        }
    }

    var filteredMangas: [UserManga] {
        switch selectedFilter {
        case .todo:
            return mangas
        case .porEmpezar:
            return mangas.filter { ($0.readingVolume ?? 0) == 0 }
        case .leyendo:
            return mangas.filter {
                guard let total = $0.totalVolumes else { return ($0.readingVolume ?? 0) > 0 }
                let reading = $0.readingVolume ?? 0
                return reading > 0 && reading < total
            }
        case .leidos:
            return mangas.filter {
                guard let total = $0.totalVolumes else { return false }
                return ($0.readingVolume ?? 0) >= total
            }
        case .completados:
            return mangas.filter {
                guard let total = $0.totalVolumes, total > 0 else { return false }
                return ($0.readingVolume ?? 0) >= total
            }
        }
    }

    // MARK: - Collection Stats

    struct CollectionStats {
        let total: Int
        let reading: Int
        let volumesOwned: Int
        let complete: Int
    }

    var collectionStats: CollectionStats {
        let reading = mangas.filter {
            guard let total = $0.totalVolumes else { return false }
            let r = $0.readingVolume ?? 0
            return r > 0 && r < total
        }.count
        let complete = mangas.filter { $0.completeCollection }.count
        let volumes = mangas.reduce(0) { $0 + $1.volumesOwned.count }
        return CollectionStats(
            total: mangas.count,
            reading: reading,
            volumesOwned: volumes,
            complete: complete
        )
    }
    
    init(
        context: ModelContext,
        repository: MangaCollectionRepository,
        syncService: MangaCollectionSyncService,
        isAuthenticated: Bool = false
    ) {
        self.modelContext = context
        self.repository = repository
        self.syncService = syncService
        self.isAuthenticated = isAuthenticated
        self.offlineManager = OfflineOperationsManager(context: context)
        
        if isAuthenticated {
            offlineManager.onConnectionRestored = { [weak self] in
                guard let self else { return }
                await self.synchronize()
            }
        }
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
            
            if let remoteRepo = repository as? RemoteMangaCollectionRepository {
                let result = await offlineManager.processQueue(using: remoteRepo)
                if result.total > 0 {
                    print("📤 Operaciones offline procesadas: \(result.processed)/\(result.total)")
                }
            }
            
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
            guard !isAddingManga else { return }
            isAddingManga = true
            defer { isAddingManga = false }

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
            mangas.append(newUserManga)
            try? modelContext.save()
            updateWidget()

            guard isAuthenticated else { return }

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

            if offlineManager.isConnected {
                do {
                    try await repository.add(mangaData: syncData)
                    print("✅ Manga added to server")
                } catch {
                    print("⚠️ Failed to add to server, enqueueing: \(error)")
                    offlineManager.enqueue(
                        action: .add,
                        mangaID: newUserManga.mangaID,
                        mangaTitle: newUserManga.title,
                        mangaData: syncData
                    )
                }
            } else {
                print("📴 Offline - Enqueueing add operation for: \(newUserManga.title)")
                offlineManager.enqueue(
                    action: .add,
                    mangaID: newUserManga.mangaID,
                    mangaTitle: newUserManga.title,
                    mangaData: syncData
                )
            }
        }
    
    func remove(_ manga: UserManga) async {
        let idToRemove = manga.mangaID
        let syncData = manga.asSyncData
        
        modelContext.delete(manga)
        self.mangas.removeAll { $0.mangaID == idToRemove }
        try? modelContext.save()
        updateWidget()
        
        guard isAuthenticated else { return }
        
        if offlineManager.isConnected {
            do {
                try await repository.remove(manga)
                print("✅ Manga deleted from server: \(manga.title)")
            } catch {
                print("⚠️ Failed to delete from server, enqueueing: \(error)")
                offlineManager.enqueue(
                    action: .delete,
                    mangaID: idToRemove,
                    mangaTitle: manga.title,
                    mangaData: syncData
                )
            }
        } else {
            print("📴 Offline - Enqueueing delete operation for: \(manga.title)")
            offlineManager.enqueue(
                action: .delete,
                mangaID: idToRemove,
                mangaTitle: manga.title,
                mangaData: syncData
            )
        }
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
        guard isAuthenticated else {
            try? modelContext.save()
            updateWidget()
            return
        }
        
        let syncData = userManga.asSyncData
        
        if offlineManager.isConnected {
            do {
                try await repository.add(mangaData: syncData)
                print("✅ Synced with server")
                updateWidget()
            } catch {
                print("⚠️ Failed to sync, enqueueing update: \(error)")
                offlineManager.enqueue(
                    action: .update,
                    mangaID: userManga.mangaID,
                    mangaTitle: userManga.title,
                    mangaData: syncData
                )
            }
        } else {
            print("📴 Offline - Enqueueing update operation for: \(userManga.title)")
            offlineManager.enqueue(
                action: .update,
                mangaID: userManga.mangaID,
                mangaTitle: userManga.title,
                mangaData: syncData
            )
        }
    }
    
    private func updateWidget() {
        Task { @MainActor in
            let readingMangas: [ReadingManga] = mangas.compactMap { manga in
                guard let readingVolume = manga.readingVolume, readingVolume > 0 else {
                    return nil
                }
                
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
}
