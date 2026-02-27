//
//  UserMangaDetailViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
final class UserMangaDetailViewModel {

    // MARK: - Dependencies

    private let collectionVM: UserMangaCollectionViewModel
    private(set) var userManga: UserManga

    // MARK: - State

    var volumesOwned: Set<Int>
    var readingVolume: Int
    var manga: Manga? = nil
    var isLoadingManga = false

    // MARK: - Initialization

    init(
        userManga: UserManga,
        collectionVM: UserMangaCollectionViewModel
    ) {
        self.userManga = userManga
        self.collectionVM = collectionVM
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
        guard let definedTotal = userManga.totalVolumes, definedTotal > 0 else {
            return false
        }
        return volumesOwned.count == definedTotal
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
        if let definedTotal = userManga.totalVolumes {
            readingVolume = min(readingVolume, definedTotal)
        }

        userManga.readingVolume = readingVolume == 0 ? nil : readingVolume
        userManga.volumesOwned = Array(volumesOwned).sorted()
        userManga.completeCollection = isCompleteCollection
        userManga.updatedAt = .now

        Task {
            await collectionVM.updateRemote(userManga)
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
