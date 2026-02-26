//
//  AddMangaViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

@Observable
@MainActor
final class AddMangaViewModel {

    // MARK: - Dependencies
    private let collectionVM: UserMangaCollectionViewModel
    let manga: Manga

    // MARK: - State
    var volumesOwned: Set<Int> = []
    var readingVolume: Int = 0
    var isAdding = false

    // MARK: - Init
    init(manga: Manga, collectionVM: UserMangaCollectionViewModel) {
        self.manga = manga
        self.collectionVM = collectionVM
    }

    // MARK: - Computed Properties

    var totalVolumes: Int {
        max(manga.volumes ?? 0, 0)
    }

    var maxVolume: Int {
        totalVolumes > 0 ? totalVolumes : 999
    }

    var isCompleteCollection: Bool {
        totalVolumes > 0 && volumesOwned.count == totalVolumes
    }

    var hasDynamicTotal: Bool {
        manga.volumes == nil || manga.volumes == 0
    }

    // MARK: - Actions

    func addToCollection() async {
        guard !isAdding else { return }
        isAdding = true
        await collectionVM.add(
            manga: manga,
            volumesOwned: Array(volumesOwned).sorted(),
            readingVolume: readingVolume == 0 ? nil : readingVolume,
            completeCollection: isCompleteCollection
        )
        isAdding = false
    }

    func selectAllVolumes() {
        guard totalVolumes > 0 else { return }
        volumesOwned = Set(1...totalVolumes)
    }

    func clearAllVolumes() {
        volumesOwned.removeAll()
    }

    func invertSelection() {
        guard totalVolumes > 0 else { return }
        volumesOwned = Set(1...totalVolumes).subtracting(volumesOwned)
    }
}
