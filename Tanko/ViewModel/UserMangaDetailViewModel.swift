//
//  UserMangaDetailViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class UserMangaDetailViewModel {

    // MARK: - Dependencies
    private let collectionVM: UserMangaCollectionViewModel
    private let modelContext: ModelContext

    // Store the ID to re-fetch if needed
    private let mangaPersistentID: PersistentIdentifier

    private(set) var userManga: UserManga

    // MARK: - State
    var volumesOwned: Set<Int>
    var readingVolume: Int
    var manga: Manga? = nil
    var isLoadingManga = false

    // MARK: - Initialization
    init(
        userManga: UserManga,
        collectionVM: UserMangaCollectionViewModel,
        modelContext: ModelContext
    ) {
        self.userManga = userManga
        self.mangaPersistentID = userManga.persistentModelID
        self.collectionVM = collectionVM
        self.modelContext = modelContext
        self.volumesOwned = Set(userManga.volumesOwned)
        self.readingVolume = userManga.readingVolume ?? 0
    }

    // MARK: - Computed Properties

    var totalVolumes: Int {
        if let definedTotal = userManga.totalVolumes, definedTotal > 0 {
            return definedTotal
        }
        return max(readingVolume, volumesOwned.max() ?? 0, 10)
    }

    var maxVolume: Int {
        if let definedTotal = userManga.totalVolumes, definedTotal > 0 {
            return definedTotal
        }
        return 999
    }

    var isCompleteCollection: Bool {
        guard let definedTotal = userManga.totalVolumes, definedTotal > 0 else { return false }
        return volumesOwned.count == definedTotal
    }

    var isFullyRead: Bool {
        guard let definedTotal = userManga.totalVolumes, definedTotal > 0 else { return false }
        return readingVolume >= definedTotal
    }

    var hasDynamicTotal: Bool {
        userManga.totalVolumes == nil
    }

    var shouldShowCollectionState: Bool {
        userManga.totalVolumes != nil
    }

    var readingProgressFooter: LocalizedStringKey {
        if let total = userManga.totalVolumes, total > 0 {
            return "reading.footer.one \(total)"
        }
        return "reading.footer.two"
    }

    var volumesFooter: String {
        "\(volumesOwned.count) / \(totalVolumes)"
    }

    // MARK: - Actions

    func saveChanges() {
        // Re-fetch the object from the context to ensure it's not detached
        guard let liveObject = modelContext.model(for: mangaPersistentID) as? UserManga else {
            print("⚠️ UserManga separado del contexto, omitiendo guardar")
            return
        }

        if let definedTotal = liveObject.totalVolumes {
            readingVolume = min(readingVolume, definedTotal)
        }
        liveObject.readingVolume = readingVolume == 0 ? nil : readingVolume
        liveObject.volumesOwned = Array(volumesOwned).sorted()
        liveObject.completeCollection = isCompleteCollection
        liveObject.updatedAt = .now
        userManga = liveObject

        try? modelContext.save()

        Task {
            await collectionVM.updateRemote(liveObject)
        }
    }

    func incrementReading() {
        guard readingVolume < maxVolume else { return }
        readingVolume += 1
        saveChanges()
    }

    func decrementReading() {
        guard readingVolume > 0 else { return }
        readingVolume -= 1
        saveChanges()
    }

    func selectAllVolumes() {
        volumesOwned = Set(1...totalVolumes)
        saveChanges()
    }

    func clearAllVolumes() {
        volumesOwned.removeAll()
        saveChanges()
    }

    func invertSelection() {
        volumesOwned = Set(1...totalVolumes).subtracting(volumesOwned)
        saveChanges()
    }

    func toggleVolume(_ number: Int) {
        if volumesOwned.contains(number) {
            volumesOwned.remove(number)
        } else {
            volumesOwned.insert(number)
        }
        saveChanges()
    }

    func loadManga() async {
        guard manga == nil, !isLoadingManga else { return }
        isLoadingManga = true
        do {
            let network = Network()
            manga = try await network.getManga(id: userManga.mangaID)
        } catch {
            print("❌ Error cargando manga completo: \(error)")
        }
        isLoadingManga = false
    }
}
