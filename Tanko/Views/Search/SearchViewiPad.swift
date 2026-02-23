//
//  SearchViewiPad.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import SwiftData
import SwiftUI

struct SearchViewiPad: View {
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM
    
    @State private var searchText = ""
    @State private var viewModel = SearchViewModel()
    @State private var filtersViewModel = FiltersViewModel()
    @State private var searchTask: Task<Void, Never>?
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
        .onChange(of: router.pendingSearchFilter) { _, filter in
            guard let filter else { return }
            router.pendingSearchFilter = nil
            navigationPath = NavigationPath()
            applyPendingFilter(filter)
        }
        .onAppear {
            if let filter = router.pendingSearchFilter {
                router.pendingSearchFilter = nil
                navigationPath = NavigationPath()
                applyPendingFilter(filter)
            }
        }
    }

    // MARK: - Filters Sidebar

    private var filtersSidebar: some View {
        List {
            Section {
                // Search by text
                Section(header: Text("Búsqueda por texto").font(.headline)) {
                    TextField(
                        "Título del manga",
                        text: $filtersViewModel.searchTitle
                    )
                    .textFieldStyle(.roundedBorder)

                    TextField(
                        "Nombre del autor",
                        text: $filtersViewModel.searchAuthorFirstName
                    )
                    .textFieldStyle(.roundedBorder)

                    TextField(
                        "Apellido del autor",
                        text: $filtersViewModel.searchAuthorLastName
                    )
                    .textFieldStyle(.roundedBorder)

                    Toggle(
                        "Búsqueda parcial",
                        isOn: $filtersViewModel.containsSearch
                    )
                }

                // Genre
                DisclosureGroup {
                    ForEach(filtersViewModel.availableGenres) { genre in
                        MultiSelectionRow(
                            title: genre.localized,
                            isSelected: filtersViewModel.selectedGenres
                                .contains(genre)
                        ) {
                            toggleGenre(genre)
                        }
                    }
                } label: {
                    HStack {
                        Text("Géneros")
                        Spacer()
                        if !filtersViewModel.selectedGenres.isEmpty {
                            Text("\(filtersViewModel.selectedGenres.count)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .clipShape(Capsule())
                        }
                    }
                }

                // Theme
                DisclosureGroup {
                    ForEach(filtersViewModel.availableThemes) { theme in
                        MultiSelectionRow(
                            title: theme.localized,
                            isSelected: filtersViewModel.selectedThemes
                                .contains(theme)
                        ) {
                            toggleTheme(theme)
                        }
                    }
                } label: {
                    HStack {
                        Text("Temáticas")
                        Spacer()
                        if !filtersViewModel.selectedThemes.isEmpty {
                            Text("\(filtersViewModel.selectedThemes.count)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.orange)
                                .clipShape(Capsule())
                        }
                    }
                }

                // Demographic
                DisclosureGroup {
                    ForEach(filtersViewModel.availableDemographics) { demo in
                        MultiSelectionRow(
                            title: demo.localized,
                            isSelected: filtersViewModel.selectedDemographics
                                .contains(demo)
                        ) {
                            toggleDemographic(demo)
                        }
                    }
                } label: {
                    HStack {
                        Text("Demografía")
                        Spacer()
                        if !filtersViewModel.selectedDemographics.isEmpty {
                            Text(
                                "\(filtersViewModel.selectedDemographics.count)"
                            )
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.pink)
                            .clipShape(Capsule())
                        }
                    }
                }
            }

            // Action buttons
            Section {
                Button {
                    applyFilters()
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Buscar")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if filtersViewModel.hasActiveFilters {
                    Button(role: .destructive) {
                        filtersViewModel.resetAllFilters()
                        applyCurrentFilters()
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Limpiar filtros")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Filtros")
    }

    // MARK: - Search Results Detail

    private var searchResultsDetail: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                switch viewModel.state {
                case .idle:
                    emptySearchState

                case .loading:
                    ProgressView("Buscando...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded:
                    searchResultsList

                case .empty:
                    noResultsState

                case .error(let message):
                    errorState(message: message)
                }
            }
            .navigationTitle("Resultados")
            .navigationBarTitleDisplayModeCompatible(.inline)
            .searchable(text: $searchText, prompt: "Buscar manga…")
            .onChange(of: searchText) { _, newValue in
                performSearch(query: newValue)
            }
            .navigationDestination(for: MangaNavigation.self) { nav in
                MangaDetailView(manga: nav.manga, namespace: nil)
            }
            .navigationDestination(for: Author.self) { author in
                AuthorMangaViewiPad(author: author)
            }
        }
    }

    // MARK: - Helper Methods

    private func toggleGenre(_ genre: Genre) {
        if filtersViewModel.selectedGenres.contains(genre) {
            filtersViewModel.selectedGenres.remove(genre)
        } else {
            filtersViewModel.selectedGenres.insert(genre)
        }
    }

    private func toggleTheme(_ theme: Theme) {
        if filtersViewModel.selectedThemes.contains(theme) {
            filtersViewModel.selectedThemes.remove(theme)
        } else {
            filtersViewModel.selectedThemes.insert(theme)
        }
    }

    private func toggleDemographic(_ demo: Demographic) {
        if filtersViewModel.selectedDemographics.contains(demo) {
            filtersViewModel.selectedDemographics.remove(demo)
        } else {
            filtersViewModel.selectedDemographics.insert(demo)
        }
    }

    private func performSearch(query: String) {
        searchTask?.cancel()
        isSearchFocused = false

        guard !query.isEmpty else {
            viewModel.reset()
            filtersViewModel.resetAllFilters()
            return
        }

        if filtersViewModel.hasActiveFilters {
            filtersViewModel.resetAllFilters()
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }
            await viewModel.search(mode: .simple(title: query))
        }
    }

    private func applyFilters() {
        navigationPath.removeLast(navigationPath.count)

        isSearchFocused = false

        let dto = filtersViewModel.createSearchDTO()
        Task {
            await viewModel.search(mode: .advanced(dto: dto))
        }
    }

    private func applyCurrentFilters() {
        if !filtersViewModel.hasActiveFilters {
            viewModel.reset()
            searchText = ""
            return
        }
        let dto = filtersViewModel.createSearchDTO()
        Task {
            await viewModel.search(mode: .advanced(dto: dto))
        }
    }

    private func applyPendingFilter(_ dto: CustomSearchDTO) {
        searchText = ""
        searchTask?.cancel()
        isSearchFocused = false
        navigationPath = NavigationPath()
        filtersViewModel.applyFromDTO(dto)
        Task {
            await viewModel.search(mode: .advanced(dto: dto))
        }
    }

    // MARK: - Views

    private var emptySearchState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("Buscar Manga")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Usa los filtros de la izquierda o escribe en el buscador")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var noResultsState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("No se encontraron resultados")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Intenta buscar con otros términos o filtros")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)

            Text("Error")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Reintentar") {
                Task {
                    let mode: SearchMode
                    if filtersViewModel.hasActiveFilters {
                        let dto = filtersViewModel.createSearchDTO()
                        mode = .advanced(dto: dto)
                    } else {
                        mode = .simple(title: searchText)
                    }

                    await viewModel.search(mode: mode)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var searchResultsList: some View {
        List {
            ForEach(Array(viewModel.results.enumerated()), id: \.element.id) {
                index,
                manga in
                let isFirst = index == 0
                let isLast = index == viewModel.results.count - 1

                NavigationLink(value: MangaNavigation.withoutTransition(manga)) {
                    MangaRow(
                        manga: manga,
                        namespace: namespace,
                        showBackground: false
                    )
                }
                .listRowSeparator(isFirst ? .hidden : .visible, edges: .top)
                .listRowSeparator(isLast ? .hidden : .visible, edges: .bottom)
                .listRowSeparatorTint(.surface)
                .listRowInsets(
                    EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 15)
                )
                .onAppear {
                    Task {
                        await viewModel.loadNextPageIfNeeded(currentItem: manga)
                    }
                }
            }

            if viewModel.canLoadMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchViewiPad()
        .withPreviewEnvironment()
}
