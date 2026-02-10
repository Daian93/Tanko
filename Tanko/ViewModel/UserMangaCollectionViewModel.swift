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

    init(context: ModelContext, repository: MangaCollectionRepository, localRepo: LocalMangaCollectionRepository, remoteRepo: RemoteMangaCollectionRepository?) {
        self.modelContext = context
        self.repository = repository
        self.localRepo = localRepo
        self.remoteRepo = remoteRepo
    }

    func loadCollection() async {
        do {
            let items = try await repository.getCollection()
            // Importante: Actualizar la lista en memoria para que la UI reaccione
            self.mangas = items
            
            // Sincronizar el ModelContext de SwiftData
            let fetch = FetchDescriptor<UserManga>()
            let local = try modelContext.fetch(fetch)
            for m in local { modelContext.delete(m) }
            for m in items { modelContext.insert(m) }
            
            try modelContext.save()
        } catch {
            print("❌ Error cargando colección:", error)
        }
    }

    // Corregido: Ahora acepta los parámetros de la vista
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
        // Insertamos en memoria inmediatamente para feedback instantáneo
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
