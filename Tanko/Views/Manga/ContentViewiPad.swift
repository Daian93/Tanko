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
    @Environment(AppSettings.self) private var settings

    @State private var bestMangaViewModel = BestMangaViewModel()

    @Namespace private var namespace

    var body: some View {
        @Bindable var mangasVM = viewModel

        NavigationStack {
            Group {
                switch viewModel.state {

                // MARK: - LOADING
                case .loading:
                    MangaLoadingView()

                // MARK: - LOADED
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
                                Text("tab.mangas")
                                    .font(.system(size: 30, weight: .bold))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    #if os(macOS)
                                        .padding(.horizontal)
                                        .padding(.top)
                                    #endif

                                if !bestMangaViewModel.mangas.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("content.best")
                                            .font(.title3)
                                            .foregroundStyle(.tankoPrimary)
                                            .bold()
                                            .padding(.horizontal)

                                        MangaCarousel(
                                            mangas: bestMangaViewModel.mangas,
                                            namespace: namespace
                                        )
                                    }
                                }

                                VStack(alignment: .leading, spacing: 12) {
                                    Text("content.all")
                                        .font(.title3)
                                        .foregroundStyle(.tankoPrimary)
                                        .bold()
                                        .padding(.horizontal)

                                    LazyVGrid(columns: gridItems, spacing: 20) {
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

                                if viewModel.canLoadMore {
                                    ProgressView().padding()
                                }
                            }
                            .padding(.vertical)
                            .background(.tankoBackground)
                        }
                        .refreshable {
                            await viewModel.refresh()
                            await bestMangaViewModel.refresh()
                        }
                    }

                // MARK: - EMPTY
                case .empty:
                    MangaEmptyView {
                        await viewModel.refresh()
                        await bestMangaViewModel.refresh()
                    }

                // MARK: - ERROR
                case .error(let message):
                    MangaErrorView(message: message) {
                        await viewModel.refresh()
                        await bestMangaViewModel.refresh()
                    }
                }
            }
            .navigationTitle("tab.mangas")
            .navigationBarTitleDisplayModeCompatible(.inline)
            .background(.tankoBackground)
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga, namespace: nil)
            }
            .navigationDestination(for: MangaNavigation.self) { nav in
                switch nav {
                case .withTransition(let manga):
                    MangaDetailView(manga: manga, namespace: namespace)
                case .withoutTransition(let manga):
                    MangaDetailView(manga: manga, namespace: nil)
                }
            }
            .navigationDestination(for: Author.self) { author in
                AuthorMangaViewiPad(author: author)
            }
            .sheet(item: $mangasVM.selectedMangaForCollection) { manga in
                AddMangaToCollectionView(manga: manga)
            }
        }
        .id(settings.appLanguage)
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
}

#Preview {
    ContentViewiPad()
        .withPreviewEnvironment()
}
