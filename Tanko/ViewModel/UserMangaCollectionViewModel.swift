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

    private var modelContext: ModelContext?
    private var repositoryFactory: CollectionRepositoryFactory?

    var refreshTrigger: Int = 0

    func setContext(_ context: ModelContext, factory: CollectionRepositoryFactory? = nil) {
        self.modelContext = context
        self.repositoryFactory = factory
    }

    // MARK: - Carga de colección
    func loadCollection() async {
        guard let repo = repositoryFactory?.repository,
              let context = modelContext else { return }

        do {
            let userCollection = try await repo.getCollection()

            let fetch = FetchDescriptor<UserManga>()
            let existing = (try? context.fetch(fetch)) ?? []
            for item in existing { context.delete(item) }

            for userManga in userCollection { context.insert(userManga) }
            saveAndRefresh()
        } catch {
            print("Error cargando colección inicial: \(error)")
        }
    }

    // MARK: - Escritura
    func addToCollection(
        manga: Manga,
        volumesOwned: [Int] = [],
        readingVolume: Int? = nil,
        completeCollection: Bool = false
    ) async {
        guard let context = modelContext else { return }
        if isInCollection(mangaID: manga.id) { return }

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
        saveAndRefresh()

        if let repo = repositoryFactory?.repository as? RemoteMangaCollectionRepository {
            await syncAddRemote(repo: repo, manga: userManga)
        }
    }

    func removeFromCollection(userMangaID: UUID) async {
        guard let context = modelContext else { return }
        let fetch = FetchDescriptor<UserManga>(predicate: #Predicate { $0.id == userMangaID })

        if let userManga = (try? context.fetch(fetch))?.first {
            context.delete(userManga)
            saveAndRefresh()

            if let repo = repositoryFactory?.repository as? RemoteMangaCollectionRepository {
                await syncRemoveRemote(repo: repo, manga: userManga)
            }
        }
    }

    // MARK: - Consultas
    func isInCollection(mangaID: Int) -> Bool {
        _ = refreshTrigger
        guard let context = modelContext else { return false }
        let fetch = FetchDescriptor<UserManga>(predicate: #Predicate { $0.mangaID == mangaID })
        return ((try? context.fetchCount(fetch)) ?? 0) > 0
    }

    var mangas: [UserManga] {
        _ = refreshTrigger
        guard let context = modelContext else { return [] }
        return (try? context.fetch(FetchDescriptor<UserManga>())) ?? []
    }

    // MARK: - Actualizaciones
    func updateVolumes(userMangaID: UUID, volumesOwned: [Int]) async {
        await modifyManga(userMangaID: userMangaID) { $0.volumesOwned = volumesOwned }
    }

    func updateReadingVolume(userMangaID: UUID, readingVolume: Int?) async {
        await modifyManga(userMangaID: userMangaID) { $0.readingVolume = readingVolume }
    }

    func updateCompleteStatus(userMangaID: UUID, completeCollection: Bool) async {
        await modifyManga(userMangaID: userMangaID) { $0.completeCollection = completeCollection }
    }

    // MARK: - Helpers privados
    private func saveAndRefresh() {
        try? modelContext?.save()
        refreshTrigger += 1
    }

    private func modifyManga(userMangaID: UUID, action: (UserManga) -> Void) async {
        guard let context = modelContext else { return }
        let fetch = FetchDescriptor<UserManga>(predicate: #Predicate { $0.id == userMangaID })

        if let userManga = (try? context.fetch(fetch))?.first {
            action(userManga)
            saveAndRefresh()

            if let repo = repositoryFactory?.repository as? RemoteMangaCollectionRepository {
                await syncAddRemote(repo: repo, manga: userManga)
            }
        }
    }

    // MARK: - Sincronización segura remota
    private func syncAddRemote(repo: RemoteMangaCollectionRepository, manga: UserManga) async {
        let copy = UserManga(
            id: manga.id,
            mangaID: manga.mangaID,
            title: manga.title,
            coverURL: manga.coverURL,
            totalVolumes: manga.totalVolumes,
            volumesOwned: manga.volumesOwned,
            readingVolume: manga.readingVolume,
            completeCollection: manga.completeCollection
        )
        
        do {
            try await repo.add(copy)
        } catch {
            print("Error sincronizando manga remoto: \(error)")
        }
    }

    private func syncRemoveRemote(repo: RemoteMangaCollectionRepository, manga: UserManga) async {
        let copy = UserManga(
            id: manga.id,
            mangaID: manga.mangaID,
            title: manga.title,
            coverURL: manga.coverURL,
            totalVolumes: manga.totalVolumes,
            volumesOwned: manga.volumesOwned,
            readingVolume: manga.readingVolume,
            completeCollection: manga.completeCollection
        )
        
        do {
            try await repo.remove(copy)
        } catch {
            print("Error eliminando manga remoto: \(error)")
        }
    }

}
