//
//  ContentView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(MangasViewModel.self) private var viewModel
    @State private var bestMangasViewModel = BestMangasViewModel()
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
                            if !bestMangasViewModel.mangas.isEmpty {
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
                            }
                            
                            ForEach(viewModel.mangas) { manga in
                                NavigationLink(value: manga) {
                                    MangaRow(manga: manga, namespace: namespace)
                                        .background(AppColors.surface)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 20)
                                        )
                                        .padding(.horizontal)
                                        .onAppear {
                                            Task {
                                                await viewModel
                                                    .loadNextPageIfNeeded(
                                                        currentItem: manga
                                                    )
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                            
                            // ⏳ Loader scroll infinito
                            if viewModel.canLoadMore {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding(.vertical)
                        .background(AppColors.background)
                    }
                    .navigationDestination(for: Manga.self) { manga in
                        MangaDetailView(manga: manga, namespace: namespace)
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
        }
        .task {
            await viewModel.getMangas()
            await bestMangasViewModel.getBestMangas()
        }
        .alert("error.title", isPresented: $mangasVM.showError) {
            Button("button.ok", role: .cancel) {}
        } message: {
            Text(viewModel.errorMsg)
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

#Preview {
    ContentView()
        .environment(MangasViewModel())
}
