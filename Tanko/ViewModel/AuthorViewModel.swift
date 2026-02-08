//
//  AuthorViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 8/2/26.
//

import SwiftUI

enum AuthorViewState {
    case idle
    case loading
    case loaded
    case empty
}

@Observable
@MainActor
final class AuthorViewModel {

    let repository: NetworkRepository
    let author: Author

    var mangas: [Manga] = []
    var state: AuthorViewState = .loading

    var showError = false
    var errorMsg = ""

    private var isLoadingPage = false
    private var currentPage = NetworkConstants.defaultPage
    private var perPage = NetworkConstants.defaultPerPage
    private var hasMorePages = true

    init(
        author: Author,
        repository: NetworkRepository = Network()
    ) {
        self.author = author
        self.repository = repository
    }

    // MARK: - Initial load
    func loadInitial() async {
        guard mangas.isEmpty else { return }
        await getMangas()
    }

    private func getMangas() async {
        state = .loading

        do {
            let page = try await repository.getMangasByAuthor(
                author.id.uuidString,
                page: currentPage,
                per: perPage
            )

            mangas = page.items
            hasMorePages = page.metadata.hasNextPage
            state = mangas.isEmpty ? .empty : .loaded

        } catch {
            errorMsg = error.localizedDescription
            showError = true
            state = .empty
        }
    }

    // MARK: - Pagination
    func loadNextPageIfNeeded(currentItem manga: Manga) async {
        guard
            hasMorePages,
            !isLoadingPage,
            state == .loaded,
            mangas.last?.id == manga.id
        else { return }

        await loadNextPage()
    }

    private func loadNextPage() async {
        isLoadingPage = true
        currentPage += 1

        do {
            let page = try await repository.getMangasByAuthor(
                author.id.uuidString,
                page: currentPage,
                per: perPage
            )

            mangas.append(contentsOf: page.items)
            hasMorePages = page.metadata.hasNextPage

        } catch {
            currentPage -= 1
            errorMsg = error.localizedDescription
            showError = true
        }

        isLoadingPage = false
    }

    // MARK: - Refresh
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
