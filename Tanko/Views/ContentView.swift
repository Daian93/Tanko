//
//  ContentView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(UserMangaCollectionViewModel.self) private var userCollectionVM
    @Environment(MangaViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
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
                        .background(.tankoBackground)

                case .loaded:
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("content.best")
                                    .font(.title3)
                                    .foregroundStyle(.tankoPrimary)
                                    .bold()
                                    .padding(.horizontal)
                                
                                // Carousel of best mangas
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
                            
                            // All mangas list with infinite scrolling
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
                        .background(.tankoBackground)
                    }
                    .refreshable {
                        await viewModel.refresh()
                        await bestMangaViewModel.refresh()
                    }

                case .empty:
                    ContentUnavailableView(
                        "content.empty.title",
                        systemImage: "book.closed",
                        description: Text("content.empty.description")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.tankoBackground)
                }
            }
            .navigationTitle("tab.mangas")
            .background(.tankoBackground)
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
            await bestMangaViewModel.getBestMangas()
        }
    }
}

#Preview {
    ContentView()
        .withPreviewEnvironment()
}
