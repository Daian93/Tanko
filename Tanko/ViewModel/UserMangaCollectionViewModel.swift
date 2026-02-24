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

    var selectedFilter: CollectionFilter = .all

    enum CollectionFilter: String, CaseIterable {
        case all = "collection.filter.all"
        case toRead = "collection.filter.to.read"
        case reading = "collection.filter.reading"
        case read = "collection.filter.read"
        case complete = "collection.filter.complete"

        var localized: LocalizedStringKey {
            LocalizedStringKey(self.rawValue)
        }
    }

    var filteredMangas: [UserManga] {
        switch selectedFilter {
        case .all:
            return mangas

        case .toRead:
            return mangas.filter { ($0.readingVolume ?? 0) == 0 }

        case .reading:
            return mangas.filter {
                let reading = $0.readingVolume ?? 0
                guard reading > 0 else { return false }
                if let total = $0.totalVolumes, total > 0 {
                    return reading < total
                }
                return true
            }

        case .read:
            return mangas.filter {
                guard let total = $0.totalVolumes, total > 0 else {
                    return false
                }
                return ($0.readingVolume ?? 0) >= total
            }

        case .complete:
            return mangas.filter { $0.completeCollection }
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
            let r = $0.readingVolume ?? 0
            guard r > 0 else { return false }
            if let total = $0.totalVolumes, total > 0 { return r < total }
            return true
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

    // Call before destroying the VM to stop network monitoring safely
    func invalidate() {
        offlineManager.stopMonitoring()
        mangas.removeAll()
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
                let result = await offlineManager.processQueue(
                    using: remoteRepo
                )
                if result.total > 0 {
                    print(
                        "📤 Operaciones offline procesadas: \(result.processed)/\(result.total)"
                    )
                }
            }

            try await syncService.sync()
            print("✅ Sincronización completada. Recargando datos...")
            await reloadFromLocalDatabase()
        } catch NetworkError.cancelled {
            print("⚠️ Sincronización cancelada")
        } catch NetworkError.invalidJSON {
            print(
                "⚠️ El servidor respondió correctamente, pero no hay ningún JSON válido."
            )
        } catch {
            print("❌ Error durante la sincronización: \(error)")
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
            print("⚠️ Carga cancelada")
        } catch {
            print("❌ Error al cargar la colección: \(error)")
        }
    }

    // MARK: - Private helper to reload from local database

    private func reloadFromLocalDatabase() async {
        do {
            let descriptor = FetchDescriptor<UserManga>(
                sortBy: [SortDescriptor(\UserManga.title)]
            )

            self.mangas = try modelContext.fetch(descriptor)
            print("✅ Colección local actualizada: \(mangas.count) mangas")

            // Update widget after reloading
            updateWidget()
        } catch {
            print("❌ Error al recargar desde la base de datos local: \(error)")
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
                print("✅ Manga añadido al servidor")
            } catch {
                print(
                    "⚠️ No se ha podido añadir al servidor, poniendo en cola: \(error)"
                )
                offlineManager.enqueue(
                    action: .add,
                    mangaID: newUserManga.mangaID,
                    mangaTitle: newUserManga.title,
                    mangaData: syncData
                )
            }
        } else {
            print(
                "📴 Sin conexión: operación de adición en cola para: \(newUserManga.title)"
            )
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
                print("✅ Manga eliminado del servidor: \(manga.title)")
            } catch {
                print(
                    "⚠️ No se ha podido eliminar del servidor, poniendo en cola: \(error)"
                )
                offlineManager.enqueue(
                    action: .delete,
                    mangaID: idToRemove,
                    mangaTitle: manga.title,
                    mangaData: syncData
                )
            }
        } else {
            print(
                "📴 Sin conexión: operación de eliminación en cola para: \(manga.title)"
            )
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
                print("✅ Sincronizado con el servidor")
                updateWidget()
            } catch {
                print(
                    "⚠️ Error al sincronizar, poniendo en cola la actualización: \(error)"
                )
                offlineManager.enqueue(
                    action: .update,
                    mangaID: userManga.mangaID,
                    mangaTitle: userManga.title,
                    mangaData: syncData
                )
            }
        } else {
            print(
                "📴 Sin conexión: operación de actualización en cola para: \(userManga.title)"
            )
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
                guard let readingVolume = manga.readingVolume, readingVolume > 0
                else {
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
