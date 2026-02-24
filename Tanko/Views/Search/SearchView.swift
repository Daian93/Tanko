//
//  SearchView.swift
//  Tanko
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM

    @State private var viewModel = SearchViewModel()
    @State private var filtersVM = FiltersViewModel()
    @State private var showFilters = false
    @State private var router = NavigationRouter.shared
    @State private var localPath = NavigationPath()

    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $localPath) {
            VStack(spacing: 0) {
                Group {
                    switch viewModel.state {
                    case .idle:
                        SearchEmptyState()

                    case .loading:
                        SearchLoadingState()

                    case .loaded:
                        VStack(spacing: 0) {
                            if filtersVM.hasActiveFilters {
                                ActiveFiltersChips(
                                    filtersVM: filtersVM,
                                    onFiltersChanged: {
                                        viewModel.applyCurrentFilters(filtersVM: filtersVM)
                                    }
                                )
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(.tankoBackground)
                            }
                            SearchResultsList(
                                results: viewModel.results,
                                canLoadMore: viewModel.canLoadMore,
                                namespace: namespace,
                                isInCollection: { collectionVM.isInCollection(mangaID: $0) },
                                onLoadMore: { viewModel.loadNextPageIfNeeded(currentItem: $0) }
                            )
                        }

                    case .empty:
                        SearchNoResultsState()

                    case .error(let message):
                        SearchErrorState(message: message) {
                            viewModel.retry(filtersVM: filtersVM)
                        }
                    }
                }
            }
            .navigationTitle("tab.search")
            .background(.tankoBackground)
            .navigationDestination(for: MangaNavigation.self) { nav in
                switch nav {
                case .withTransition(let manga):
                    MangaDetailView(manga: manga, namespace: namespace)
                case .withoutTransition(let manga):
                    MangaDetailView(manga: manga, namespace: nil)
                }
            }
            .navigationDestination(for: Author.self) { author in
                AuthorMangaView(author: author)
            }
            .onChange(of: router.searchPathResetToken) { _, _ in
                localPath = NavigationPath()
            }
            .onChange(of: router.pendingSearchFilter) { _, filter in
                guard let filter else { return }
                router.pendingSearchFilter = nil
                viewModel.applyPendingFilter(filter, filtersVM: filtersVM)
            }
            .onAppear {
                if let filter = router.pendingSearchFilter {
                    router.pendingSearchFilter = nil
                    viewModel.applyPendingFilter(filter, filtersVM: filtersVM)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "search.bar")
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performSearch(query: newValue, filtersVM: filtersVM)
            }
            .toolbar {
                ToolbarItem(
                    placement: CompatibleToolbarItemPlacement.topBarTrailing.placement
                ) {
                    SearchFilterToolbarButton(
                        hasActiveFilters: filtersVM.hasActiveFilters
                    ) {
                        showFilters = true
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(filtersViewModel: filtersVM) { dto in
                    viewModel.applyFilters(dto)
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .withPreviewEnvironment()
}
