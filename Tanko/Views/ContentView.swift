//
//  ContentView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(UserMangaCollectionViewModel.self) private var userCollectionVM
    @Environment(MangaViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @State private var bestMangasViewModel = BestMangaViewModel()
    @Namespace private var namespace

    var body: some View {
        @Bindable var mangasVM = viewModel

        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("content.loading")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.background)

                case .loaded:
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("content.best")
                                    .font(.title3)
                                    .foregroundStyle(AppColors.primary)
                                    .bold()
                                    .padding(.horizontal)

                                featuredCarousel

                                Text("content.all")
                                    .font(.title3)
                                    .foregroundStyle(AppColors.primary)
                                    .bold()
                                    .padding(.horizontal)
                            }

                            ForEach(viewModel.mangas) { manga in
                                MangaCollectionRow(
                                    manga: manga,
                                    namespace: namespace,
                                    userCollectionVM: userCollectionVM
                                )
                                .onAppear {
                                    Task {
                                        await viewModel.loadNextPageIfNeeded(currentItem: manga)
                                    }
                                }
                            }

                            if viewModel.canLoadMore {
                                ProgressView().padding()
                            }
                        }
                        .padding(.vertical)
                        .background(AppColors.background)
                    }
                    .refreshable {
                        await viewModel.refresh()
                        await bestMangasViewModel.refresh()
                    }

                case .empty:
                    ContentUnavailableView(
                        "content.empty.title",
                        systemImage: "book.closed",
                        description: Text("content.empty.description")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
                }
            }
            .navigationTitle("tab.mangas")
            .background(AppColors.background)
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga, namespace: namespace)
            }
            .navigationDestination(for: Author.self) { author in
                AuthorMangaView(author: author)
            }
            .sheet(item: $mangasVM.selectedMangaForCollection) { manga in
                AddMangaToCollectionView(manga: manga)
            }
        }
        .task {
            await viewModel.getMangas()
            await bestMangasViewModel.getBestMangas()
        }
    }

    private var featuredCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 40) {
                ForEach(bestMangasViewModel.mangas) { manga in
                    NavigationLink(value: manga) {
                        MangaCard(manga: manga, namespace: namespace)
                            .frame(width: 280)
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .contentMargins(.horizontal, 60, for: .scrollContent)
    }
}

import SwiftUI

struct MangaCollectionRow: View {
    let manga: Manga
    let namespace: Namespace.ID
    let userCollectionVM: UserMangaCollectionViewModel

    @Environment(MangaViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    var body: some View {
        @Bindable var mangasVM = viewModel

        let isCollected = userCollectionVM.isInCollection(mangaID: manga.id)

        ZStack(alignment: .topTrailing) {
            NavigationLink(value: manga) {
                MangaRow(manga: manga, namespace: namespace)
                    .padding(.horizontal)
            }
            .buttonStyle(.plain)

            Button {
                if isCollected {
                    showDeleteConfirmation = true
                } else {
                    mangasVM.selectedMangaForCollection = manga
                }
            } label: {
                Image(isCollected ? "bookmark.fill.minus" : "bookmark.plus")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.primary)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .contentTransition(.symbolEffect(.replace))
            }
            .padding(.trailing, 25)
            .padding(.top, 8)
        }
        .animation(.snappy, value: isCollected)
        .alert("¿Quitar de la colección?", isPresented: $showDeleteConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Quitar", role: .destructive) {
                Task {
                    if let userManga = userCollectionVM.mangas.first(where: { $0.mangaID == manga.id }) {
                        await userCollectionVM.removeFromCollection(mangaID: userManga.mangaID)
                        dismiss()
                    }
                }
            }
        } message: {
            Text("Se eliminará '\(manga.title)' de tu colección.")
        }
    }
}


