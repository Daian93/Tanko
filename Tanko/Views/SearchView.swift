//
//  SearchView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var viewModel = SearchViewModel()
    @State private var filtersViewModel = FiltersViewModel()
    @State private var showFilters = false
    @State private var searchTask: Task<Void, Never>?
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
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
            .navigationTitle("Buscar")
            .searchable(text: $searchText, prompt: "Buscar manga…")
            .onChange(of: searchText) { _, newValue in
                performSearch(query: newValue)
            }
            .toolbar {
                filtersToolbarButton
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(filtersViewModel: filtersViewModel) { dto in
                    applyFilters(dto)
                }
            }
        }
    }

    private var filtersToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showFilters = true
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
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

    private func performSearch(query: String) {
        searchTask?.cancel()

        guard !query.isEmpty else {
            viewModel.reset()
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }

            let dto = CustomSearchDTO(
                title: query,
                contains: true
            )

            await viewModel.search(using: dto)
        }
    }

    private func applyFilters(_ dto: CustomSearchDTO) {
        searchText = ""
        searchTask?.cancel()

        Task {
            await viewModel.search(using: dto)
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
                    let dto = CustomSearchDTO(
                        title: searchText.isEmpty ? nil : searchText,
                        contains: true
                    )
                    await viewModel.search(using: dto)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var searchResultsList: some View {
        List {
            ForEach(viewModel.results) { manga in
                NavigationLink {
                    MangaDetailView(manga: manga)
                } label: {
                    MangaRow(manga: manga, namespace: namespace)
                        .task {
                            await viewModel.loadNextPageIfNeeded(
                                currentItem: manga
                            )
                        }
                }
            }

            if viewModel.canLoadMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchView()
}
