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

    @State private var mangaToDelete: Manga?
    @State private var showDeleteAlert = false
    @State private var mangaToAdd: Manga?

    private func confirmDelete(manga: Manga) {
        mangaToDelete = manga
        showDeleteAlert = true
    }

    private func addToCollection(manga: Manga) {
        mangaToAdd = manga
    }

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
            ForEach(viewModel.results) { manga in
                ZStack {
                    MangaRow(
                        manga: manga,
                        namespace: namespace,
                        isInCollection: collectionVM.isInCollection(
                            mangaID: manga.id
                        ),
                        showBackground: false
                    )

                    NavigationLink(
                        destination: MangaDetailView(
                            manga: manga,
                            namespace: namespace
                        )
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowSeparatorTint(AppColors.surface)
                    .listRowInsets(EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 12))
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    if collectionVM.isInCollection(mangaID: manga.id) {
                        Button(role: .destructive) {
                            mangaToDelete = manga
                            showDeleteAlert = true
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    } else {
                        Button {
                            mangaToAdd = manga
                        } label: {
                            Label("Añadir", systemImage: "plus")
                        }
                        .tint(.green)
                    }
                }
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
        .sheet(item: $mangaToAdd) { manga in
            AddMangaToCollectionView(manga: manga)
                .interactiveDismissDisabled()
        }
        .alert("Eliminar manga", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) {
                mangaToDelete = nil
            }
            Button("Eliminar", role: .destructive) {
                if let manga = mangaToDelete,
                    let userManga = collectionVM.mangas.first(where: {
                        $0.mangaID == manga.id
                    })
                {
                    Task {
                        await collectionVM.remove(userManga)
                        mangaToDelete = nil
                    }
                }
            }
        } message: {
            Text(
                "¿Seguro que quieres eliminar '\(mangaToDelete?.title ?? "este manga")' de tu colección?"
            )
        }
    }
}

#Preview {
    SearchView()
        .withPreviewEnvironment()
}
