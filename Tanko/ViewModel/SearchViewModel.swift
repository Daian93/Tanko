//
//  SearchViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import Foundation
import Observation

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

    private var lastSearchDTO: CustomSearchDTO?

    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }

    func search(using dto: CustomSearchDTO) async {
        reset()
        state = .loading
        lastSearchDTO = dto

        do {
            let page = try await repository.advancedSearch(
                dto,
                page: currentPage,
                per: perPage
            )

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
            results.last?.id == manga.id,
            let dto = lastSearchDTO
        else { return }

        await loadNextPage(using: dto)
    }

    private func loadNextPage(using dto: CustomSearchDTO) async {
        currentPage += 1

        do {
            let page = try await repository.advancedSearch(
                dto,
                page: currentPage,
                per: perPage
            )

            results.append(contentsOf: page.items)
            hasMorePages = page.metadata.hasNextPage

        } catch {
            currentPage -= 1
            state = .error(error.localizedDescription)
        }
    }

    func reset() {
        results.removeAll()
        currentPage = NetworkConstants.defaultPage
        hasMorePages = true
        lastSearchDTO = nil
        state = .idle
    }

    var canLoadMore: Bool {
        state == .loaded && hasMorePages
    }
}
