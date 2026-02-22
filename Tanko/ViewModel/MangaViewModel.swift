//
//  MangaViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

enum MangaViewState: Equatable {
    case loading
    case loaded
    case empty
    case error(String)
}

@Observable @MainActor
final class MangaViewModel {
    let repository: NetworkRepository

    var mangas: [Manga] = []

    var state: MangaViewState = .loading
    var selectedMangaForCollection: Manga? = nil

    var showError = false
    var errorMsg = ""

    private var isLoadingPage = false
    private var currentPage = NetworkConstants.defaultPage
    private var perPage = NetworkConstants.defaultPerPage
    private var hasMorePages = true

    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }

    func getMangas() async {
        guard mangas.isEmpty else { return }
        state = .loading
        do {
            let page = try await repository.getMangas(
                page: currentPage,
                per: perPage
            )
            self.mangas = page.items
            hasMorePages = page.metadata.hasNextPage
            state = mangas.isEmpty ? .empty : .loaded
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            state = .empty
        }
    }

    func loadNextPageIfNeeded(currentItem manga: Manga) async {
        guard
            hasMorePages,
            state == .loaded,
            mangas.last?.id == manga.id
        else { return }

        await loadNextPage()
    }

    private func loadNextPage() async {
        guard hasMorePages, !isLoadingPage else { return }
        isLoadingPage = true

        currentPage += 1

        do {
            let page = try await repository.getMangas(
                page: currentPage,
                per: perPage
            )

            mangas.append(contentsOf: page.items)
            hasMorePages = page.metadata.hasNextPage
            state = .loaded

        } catch {
            currentPage -= 1
            errorMsg = error.localizedDescription
            showError = true
        }
        
        isLoadingPage = false
    }

    func refresh() async {
        currentPage = NetworkConstants.defaultPage
        hasMorePages = true
        mangas.removeAll()
        state = .loading
        await getMangas()
    }

    var canLoadMore: Bool {
        hasMorePages
    }
}
