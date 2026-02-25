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

    // MARK: - State
    var results: [Manga] = []
    var state: SearchViewState = .idle
    var searchText: String = ""

    // MARK: - Pagination
    private var currentPage = NetworkConstants.defaultPage
    private let perPage = NetworkConstants.defaultPerPage
    private var hasMorePages = true
    private var lastSearchMode: SearchMode?
    private var isLoadingNextPage = false
    private var searchTask: Task<Void, Never>?
    private var paginationTask: Task<Void, Never>?

    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }

    // MARK: - Search Actions

    // Search with debounce for the simple search bar, and reset filters if any are active
    func performSearch(query: String, filtersVM: FiltersViewModel) {
        searchTask?.cancel()

        guard !query.isEmpty else {
            reset()
            filtersVM.resetAllFilters()
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled, let self else { return }
            await self.search(mode: .simple(title: query))
        }
    }

    // Apply the filters coming from the FiltersView
    func applyFilters(_ dto: CustomSearchDTO) {
        searchText = ""
        searchTask?.cancel()
        Task { [weak self] in
            await self?.search(mode: .advanced(dto: dto))
        }
    }

    // Apply a pending filter coming from the chips in SearchView
    func applyPendingFilter(_ dto: CustomSearchDTO, filtersVM: FiltersViewModel) {
        searchText = ""
        searchTask?.cancel()
        filtersVM.applyFromDTO(dto)
        Task { [weak self] in
            await self?.search(mode: .advanced(dto: dto))
        }
    }

    // Reapply the current active filters (used when clearing filters from the chips, to reapply the remaining ones)
    func applyCurrentFilters(filtersVM: FiltersViewModel) {
        guard filtersVM.hasActiveFilters else {
            reset()
            searchText = ""
            return
        }
        let dto = filtersVM.createSearchDTO()
        Task { [weak self] in
            await self?.search(mode: .advanced(dto: dto))
        }
    }

    // Retry the last search (used when tapping "Retry" from the error state)
    func retry(filtersVM: FiltersViewModel) {
        Task { [weak self] in
            guard let self else { return }
            let mode: SearchMode = filtersVM.hasActiveFilters
                ? .advanced(dto: filtersVM.createSearchDTO())
                : .simple(title: searchText)
            await search(mode: mode)
        }
    }

    // MARK: - Core Search

    func search(mode: SearchMode) async {
        state = .loading
        lastSearchMode = mode

        do {
            let page = try await fetchPage(for: mode, page: currentPage)
            
            guard !Task.isCancelled else { return }
            
            results = page.items
            hasMorePages = page.metadata.hasNextPage
            state = results.isEmpty ? .empty : .loaded
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            state = .error(error.localizedDescription)
        }
    }

    // MARK: - Pagination

    func loadNextPageIfNeeded(currentItem manga: Manga) {
        guard
            state == .loaded,
            hasMorePages,
            !isLoadingNextPage,
            results.last?.id == manga.id,
            let mode = lastSearchMode
        else { return }

        paginationTask?.cancel()
        paginationTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled, let self else { return }
            self.isLoadingNextPage = true
            await self.loadNextPage(using: mode)
            self.isLoadingNextPage = false
        }
    }

    private func loadNextPage(using mode: SearchMode) async {
        currentPage += 1
        isLoadingNextPage = true
        
        do {
            let page = try await fetchPage(for: mode, page: currentPage)
            guard !Task.isCancelled else { return }

            let newItems = page.items.filter { item in
                !results.contains(where: { $0.id == item.id })
            }
            
            results.append(contentsOf: newItems)
            hasMorePages = page.metadata.hasNextPage
        } catch {
            currentPage -= 1
            
            if results.isEmpty {
                state = .error(error.localizedDescription)
            } else {
                print("Error en paginación: \(error)")
                hasMorePages = false
            }
        }
        isLoadingNextPage = false
    }

    private func fetchPage(for mode: SearchMode, page: Int) async throws -> Page<Manga> {
        switch mode {
        case .simple(let title):
            if title.count < 3 {
                let items = try await repository.searchMangasBeginsWith(title)
                return Page(
                    metadata: PageMetadata(total: items.count, page: 1, per: items.count),
                    items: items
                )
            } else {
                return try await repository.searchMangasContains(title, page: page, per: perPage)
            }
        case .advanced(let dto):
            return try await repository.advancedSearch(dto, page: page, per: perPage)
        }
    }

    // MARK: - Reset

    func reset() {
        results.removeAll()
        currentPage = NetworkConstants.defaultPage
        hasMorePages = true
        lastSearchMode = nil
        state = .idle
        paginationTask?.cancel()
    }

    var canLoadMore: Bool {
        state == .loaded && hasMorePages
    }
}
