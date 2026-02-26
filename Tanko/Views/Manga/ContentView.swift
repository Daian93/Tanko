//
//  ContentView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import SwiftData
import SwiftUI

// Used for navigation when we want to specify whether to use the transition or not
enum MangaNavigation: Hashable {
    case withTransition(Manga)
    case withoutTransition(Manga)

    var manga: Manga {
        switch self {
        case .withTransition(let m), .withoutTransition(let m): return m
        }
    }
}

struct ContentView: View {
    @Environment(UserMangaCollectionViewModel.self) private var userCollectionVM
    @Environment(MangaViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettings.self) private var settings

    @State private var bestMangaViewModel = BestMangaViewModel()
    @State private var router = NavigationRouter.shared
    @State private var localPath = NavigationPath()

    @Namespace private var namespace

    var body: some View {
        @Bindable var mangasVM = viewModel

        NavigationStack(path: $localPath) {
            Group {
                switch viewModel.state {

                // MARK: - LOADING
                case .loading:
                    MangaLoadingView()

                // MARK: - LOADED
                case .loaded:
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("content.best")
                                    .font(.title3)
                                    .foregroundStyle(.tankoPrimary)
                                    .bold()
                                    .padding(.horizontal)

                                // Carousel with best mangas
                                MangaCarousel(
                                    mangas: bestMangaViewModel.mangas,
                                    namespace: namespace
                                )

                                Text("content.all")
                                    .font(.title3)
                                    .foregroundStyle(.tankoPrimary)
                                    .bold()
                                    .padding(.horizontal)
                            }

                            // List with all mangas
                            ForEach(viewModel.mangas) { manga in
                                MangaCollectionRow(
                                    manga: manga,
                                    namespace: namespace,
                                    userCollectionVM: userCollectionVM
                                )
                                .onAppear {
                                    Task {
                                        await viewModel.loadNextPageIfNeeded(
                                            currentItem: manga
                                        )
                                    }
                                }
                            }

                            if viewModel.canLoadMore {
                                ProgressView().padding()
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(.tankoBackground)
                    .refreshable {
                        await viewModel.refresh()
                        await bestMangaViewModel.refresh()
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
            .background(.tankoBackground)
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga, namespace: namespace)
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
                AuthorMangaView(author: author)
            }
            .onChange(of: router.searchPathResetToken) { _, _ in
                localPath = NavigationPath()
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
    }
}

#Preview {
    ContentView()
        .withPreviewEnvironment()
}
