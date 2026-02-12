//
//  SearchViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import Foundation
import Observation

enum SearchMode {
    case simple(title: String)
    case advanced(dto: CustomSearchDTO)
}

enum SearchViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)

    static func == (lhs: SearchViewState, rhs: SearchViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.loaded, .loaded): return true
        case (.empty, .empty): return true
        case (.error(let l), .error(let r)): return l == r
        default: return false
        }
    }
}

@Observable
@MainActor
final class SearchViewModel {
    private let repository: NetworkRepository

    var results: [Manga] = []
    var state: SearchViewState = .idle

    private var currentPage = NetworkConstants.defaultPage
    private let perPage = NetworkConstants.defaultPerPage
    private var hasMorePages = true

    private var lastSearchMode: SearchMode?
    private var isLoadingNextPage = false

    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }

    func search(mode: SearchMode) async {
        reset()
        state = .loading
        lastSearchMode = mode

        do {
            let page = try await fetchPage(for: mode, page: currentPage)

            results = page.items
            hasMorePages = page.metadata.hasNextPage
            state = results.isEmpty ? .empty : .loaded

        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func loadNextPageIfNeeded(currentItem manga: Manga) async {
        guard
            state == .loaded,
            hasMorePages,
            !isLoadingNextPage,
            results.last?.id == manga.id,
            let mode = lastSearchMode
        else { return }

        isLoadingNextPage = true
        await loadNextPage(using: mode)
        isLoadingNextPage = false
    }

    private func loadNextPage(using mode: SearchMode) async {
        currentPage += 1

        do {
            let page = try await fetchPage(for: mode, page: currentPage)
            results.append(contentsOf: page.items)
            hasMorePages = page.metadata.hasNextPage
        } catch {
            currentPage -= 1
            state = .error(error.localizedDescription)
        }
    }
    
    private func fetchPage(for mode: SearchMode, page: Int) async throws -> Page<Manga> {
        switch mode {
        case .simple(let title):
            if title.count < 3 {
                let items = try await repository.searchMangasBeginsWith(title)
                return Page(metadata: PageMetadata(total: items.count, page: 1, per: items.count), items: items)
            } else {
                return try await repository.searchMangasContains(title, page: page, per: perPage)
            }
        case .advanced(let dto):
            return try await repository.advancedSearch(dto, page: page, per: perPage)
        }
    }


    func reset() {
        results.removeAll()
        currentPage = NetworkConstants.defaultPage
        hasMorePages = true
        lastSearchMode = nil
        state = .idle
    }

    var canLoadMore: Bool {
        state == .loaded && hasMorePages
    }
}

