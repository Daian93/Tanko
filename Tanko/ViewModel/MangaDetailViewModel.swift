//
//  MangaDetailViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

@Observable
@MainActor
final class MangaDetailViewModel {

    // MARK: - Dependencies

    private let collectionVM: UserMangaCollectionViewModel

    // MARK: - State

    var showAddSheet = false
    var showDeleteAlert = false
    var mangaToDelete: UserManga? = nil

    // MARK: - Init

    init(collectionVM: UserMangaCollectionViewModel) {
        self.collectionVM = collectionVM
    }

    // MARK: - Queries

    func isInCollection(mangaID: Int) -> Bool {
        collectionVM.isInCollection(mangaID: mangaID)
    }

    // MARK: - Actions

    func toggleBookmark(manga: Manga) {
        if collectionVM.isInCollection(mangaID: manga.id) {
            if let existing = collectionVM.mangas.first(where: { $0.mangaID == manga.id }) {
                mangaToDelete = existing
                showDeleteAlert = true
            }
        } else {
            showAddSheet = true
        }
    }

    func confirmDelete(
        onDeleted: @MainActor @Sendable (UserManga) async -> Void
    ) async {
        guard let manga = mangaToDelete else { return }
        mangaToDelete = nil
        await onDeleted(manga)
    }

    func cancelDelete() {
        mangaToDelete = nil
    }
}
