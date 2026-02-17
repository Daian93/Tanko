//
//  ContentViewiPad.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

struct ContentViewiPad: View {
    @Environment(UserMangaCollectionViewModel.self) private var userCollectionVM
    @Environment(MangaViewModel.self) private var viewModel
    @State private var bestMangaViewModel = BestMangaViewModel()
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
                    GeometryReader { geo in
                        let isLandscape = geo.size.width > geo.size.height
                        let minWidth = isLandscape ? 320 : 420
                        let gridItems = [
                            GridItem(
                                .adaptive(minimum: CGFloat(minWidth)),
                                spacing: 20
                            )
                        ]

                        ScrollView {
                            VStack(spacing: 32) {

                                // BEST MANGAS
                                if !bestMangaViewModel.mangas.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("content.best")
                                            .font(.title3)
                                            .foregroundStyle(AppColors.primary)
                                            .bold()
                                            .padding(.horizontal)

                                        featuredCarousel
                                    }
                                }

                                // ALL MANGAS
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("content.all")
                                        .font(.title3)
                                        .foregroundStyle(AppColors.primary)
                                        .bold()
                                        .padding(.horizontal)

                                    LazyVGrid(
                                        columns: gridItems,
                                        spacing: 20
                                    ) {
                                        ForEach(viewModel.mangas) { manga in
                                            MangaCollectionRow(
                                                manga: manga,
                                                namespace: namespace,
                                                userCollectionVM:
                                                    userCollectionVM
                                            )
                                            .onAppear {
                                                Task {
                                                    await viewModel
                                                        .loadNextPageIfNeeded(
                                                            currentItem: manga
                                                        )
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }

                                // ⏳ Infinite scroll
                                if viewModel.canLoadMore {
                                    ProgressView()
                                        .padding()
                                }
                            }
                            .padding(.vertical)
                            .background(AppColors.background)
                        }
                    }
                    .navigationDestination(for: Manga.self) { manga in
                        MangaDetailView(manga: manga, namespace: namespace)
                    }
                    .navigationDestination(for: Author.self) { author in
                        AuthorMangaViewiPad(author: author)
                    }
                    .refreshable {
                        await viewModel.refresh()
                        await bestMangaViewModel.refresh()
                    }
                    .sheet(item: $mangasVM.selectedMangaForCollection) {
                        manga in
                        AddMangaToCollectionView(manga: manga)
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
            .navigationBarTitleDisplayModeCompatible(.inline)
            .background(AppColors.background)
        }
        .task {
            await viewModel.getMangas()
            await bestMangaViewModel.getBestMangas()
        }
        .alert("error.title", isPresented: $mangasVM.showError) {
            Button("button.ok", role: .cancel) {}
        } message: {
            Text(viewModel.errorMsg)
        }
    }

    // Best Mangas carousel
    private var featuredCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 40) {
                ForEach(bestMangaViewModel.mangas) { manga in
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

#Preview {
    ContentViewiPad()
        .withPreviewEnvironment()
}
