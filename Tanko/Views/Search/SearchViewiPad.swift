//
//  SearchViewiPad.swift
//  Tanko
//

import SwiftData
import SwiftUI

struct SearchViewiPad: View {
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM
    @Environment(AppSettings.self) private var settings

    @State private var viewModel = SearchViewModel()
    @State private var filtersVM = FiltersViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var router = NavigationRouter.shared

    @Namespace private var namespace
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        NavigationSplitView {
            filtersSidebar
        } detail: {
            searchResultsDetail
        }
        .onChange(of: router.searchPathResetToken) { _, _ in
            navigationPath = NavigationPath()
        }
        .onChange(of: router.pendingSearchFilter) { _, filter in
            guard let filter else { return }
            router.pendingSearchFilter = nil
            navigationPath = NavigationPath()
            viewModel.applyPendingFilter(filter, filtersVM: filtersVM)
        }
        .onAppear {
            if let filter = router.pendingSearchFilter {
                router.pendingSearchFilter = nil
                navigationPath = NavigationPath()
                viewModel.applyPendingFilter(filter, filtersVM: filtersVM)
            }
        }
    }

    // MARK: - Filters Sidebar

    private var filtersSidebar: some View {
        List {
            FiltersSidebarContent(filtersVM: filtersVM)

            Section {
                Button {
                    navigationPath.removeLast(navigationPath.count)
                    Task { @MainActor in
                        await Task.yield()
                        isSearchFocused = false
                    }
                    viewModel.applyFilters(filtersVM.createSearchDTO())
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("button.search")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if filtersVM.hasActiveFilters {
                    Button(role: .destructive) {
                        filtersVM.resetAllFilters()
                        viewModel.applyCurrentFilters(filtersVM: filtersVM)
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("search.clean")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("search.filters")
    }

    // MARK: - Search Results Detail

    private var searchResultsDetail: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                switch viewModel.state {
                case .idle:
                    SearchEmptyState(isIPad: true)

                case .loading:
                    SearchLoadingState()

                case .loaded:
                    SearchResultsListiPad(
                        results: viewModel.results,
                        canLoadMore: viewModel.canLoadMore,
                        namespace: namespace,
                        onLoadMore: { viewModel.loadNextPageIfNeeded(currentItem: $0) }
                    )

                case .empty:
                    SearchNoResultsState()

                case .error(let message):
                    SearchErrorState(message: message) {
                        viewModel.retry(filtersVM: filtersVM)
                    }
                }
            }
            .navigationTitle("search.results")
            .navigationBarTitleDisplayModeCompatible(.inline)
            .searchable(text: $viewModel.searchText, prompt: "search.bar")
            .onChange(of: viewModel.searchText) { _, newValue in
                Task { @MainActor in
                    await Task.yield()
                    isSearchFocused = false
                }
                viewModel.performSearch(query: newValue, filtersVM: filtersVM)
            }
            .navigationDestination(for: MangaNavigation.self) { nav in
                MangaDetailView(manga: nav.manga, namespace: nil)
            }
            .navigationDestination(for: Author.self) { author in
                AuthorMangaViewiPad(author: author)
            }
        }
        .id(settings.appLanguage)
    }
}

#Preview {
    SearchViewiPad()
        .withPreviewEnvironment()
}
