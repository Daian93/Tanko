//
//  SearchView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var viewModel = SearchViewModel()
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM
    @State private var filtersViewModel = FiltersViewModel()
    @State private var showFilters = false
    @State private var searchTask: Task<Void, Never>?
    @Namespace private var namespace

    @State private var selectedManga: Manga?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    switch viewModel.state {

                    case .idle:
                        emptySearchState

                    case .loading:
                        ProgressView("Buscando...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                    case .loaded:
                        VStack(spacing: 0) {
                            if filtersViewModel.hasActiveFilters {
                                activeFiltersChips
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color(white: 0.95))
                            }
                            searchResultsList
                        }

                    case .empty:
                        noResultsState

                    case .error(let message):
                        errorState(message: message)
                    }
                }
            }
            .navigationTitle("Buscar")
            .navigationDestination(item: $selectedManga) { manga in
                MangaDetailView(manga: manga, namespace: namespace)
            }
            .navigationDestination(for: Author.self) { author in
                AuthorMangaView(author: author)
            }
            .searchable(text: $searchText, prompt: "Buscar manga…")
            .onChange(of: searchText) { _, newValue in
                performSearch(query: newValue)
            }
            .toolbar {
                ToolbarItem(
                    placement: CompatibleToolbarItemPlacement.topBarTrailing
                        .placement
                ) {
                    Button {
                        showFilters = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(
                                systemName: "line.3.horizontal.decrease.circle"
                            )
                            .font(.title3)

                            if filtersViewModel.hasActiveFilters {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 4, y: -4)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(filtersViewModel: filtersViewModel) { dto in
                    applyFilters(dto)
                }
            }
        }
    }

    private func performSearch(query: String) {
        searchTask?.cancel()

        guard !query.isEmpty else {
            viewModel.reset()
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }

            await viewModel.search(mode: .simple(title: query))
        }
    }

    private func applyFilters(_ dto: CustomSearchDTO) {
        searchText = ""
        searchTask?.cancel()

        Task {
            await viewModel.search(mode: .advanced(dto: dto))
        }
    }

    private var emptySearchState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("Buscar Manga")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Encuentra tus mangas favoritos")
                .foregroundStyle(.secondary)
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
                let isInCollection = collectionVM.isInCollection(
                    mangaID: manga.id
                )
                let isFirst = index == 0
                let isLast = index == viewModel.results.count - 1

                NavigationLink(value: manga) {
                    MangaRow(
                        manga: manga,
                        namespace: namespace,
                        isInCollection: isInCollection,
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
        .navigationDestination(for: Manga.self) { manga in
            MangaDetailView(manga: manga, namespace: namespace)
        }
    }

    private var activeFiltersChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Título
                Text("Filtros activos:")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // Géneros
                ForEach(Array(filtersViewModel.selectedGenres), id: \.self) {
                    genre in
                    FilterChip(
                        title: genre.localized,
                        color: .green,
                        onRemove: {
                            filtersViewModel.selectedGenres.remove(genre)
                            applyCurrentFilters()
                        }
                    )
                }

                // Temáticas
                ForEach(Array(filtersViewModel.selectedThemes), id: \.self) {
                    theme in
                    FilterChip(
                        title: theme.localized,
                        color: .orange,
                        onRemove: {
                            filtersViewModel.selectedThemes.remove(theme)
                            applyCurrentFilters()
                        }
                    )
                }

                // Demografías
                ForEach(
                    Array(filtersViewModel.selectedDemographics),
                    id: \.self
                ) { demo in
                    FilterChip(
                        title: demo.localized,
                        color: .pink,
                        onRemove: {
                            filtersViewModel.selectedDemographics.remove(demo)
                            applyCurrentFilters()
                        }
                    )
                }

                // Botón limpiar todos
                if filtersViewModel.hasActiveFilters {
                    Button {
                        filtersViewModel.resetAllFilters()
                        applyCurrentFilters()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Limpiar todo")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 4)
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
}

// MARK: - Filter Chip Component
struct FilterChip: View {
    let title: LocalizedStringKey
    let color: Color
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color)
        .clipShape(Capsule())
    }
}

#Preview {
    SearchView()
        .withPreviewEnvironment()
}
