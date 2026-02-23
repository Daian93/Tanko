//
//  MangaDetailView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM
    @Environment(\.dismiss) private var dismiss

    let namespace: Namespace.ID?
    var navigationPath: Binding<NavigationPath>?

    @State private var viewModel: MangaDetailViewModel?

    private var isInCollection: Bool {
        collectionVM.isInCollection(mangaID: manga.id)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: Banner (cover + titles)
                MangaDetailBanner(manga: manga, namespace: namespace)

                Spacer(minLength: 100)

                // MARK: Stats (score, status, chapters, volumes)
                MangaDetailStats(manga: manga)

                Spacer(minLength: 20)

                // MARK: Metadata (author, genre, demoographics...)
                MangaDetailMetadata(manga: manga)

                Spacer(minLength: 20)

                // MARK: Synopsis
                ExpandableText(
                    title: "section.synopsis",
                    text: manga.synopsis
                )

                Spacer(minLength: 20)

                // MARK: Background
                ExpandableText(
                    title: "section.background",
                    text: manga.background ?? "-"
                )

                // MARK: MyAnimeList Link
                if let url = manga.url {
                    HStack {
                        Spacer()
                        Link(destination: url) {
                            Image(systemName: "arrow.up.right.square")
                                .font(.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .foregroundStyle(.white)
                                .background(.tankoPrimary.gradient)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer(minLength: 20)
            }
        }
        .navigationTitle(manga.title)
        .background(.tankoBackground)
        .navigationBarTitleDisplayModeCompatible(.inline)
        .toolbar {
            ToolbarItem(
                placement: CompatibleToolbarItemPlacement.topBarTrailing.placement
            ) {
                Button {
                    viewModel?.toggleBookmark(manga: manga)
                } label: {
                    Image(systemName: isInCollection ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isInCollection ? .tankoPrimary : .primary)
                }
                .animation(.easeInOut(duration: 0.2), value: isInCollection)
            }
        }
        .sheet(isPresented: Binding(
            get: { viewModel?.showAddSheet ?? false },
            set: { viewModel?.showAddSheet = $0 }
        )) {
            AddMangaToCollectionView(manga: manga)
                .environment(collectionVM)
        }
        .alert(
            "collection.remove",
            isPresented: Binding(
                get: { viewModel?.showDeleteAlert ?? false },
                set: { viewModel?.showDeleteAlert = $0 }
            ),
            presenting: viewModel?.mangaToDelete
        ) { manga in
            Button("button.cancel", role: .cancel) {
                viewModel?.cancelDelete()
            }
            Button("button.remove", role: .destructive) {
                Task { await handleConfirmDelete() }
            }
        } message: { manga in
            Text("collection.remove.text '\(manga.title)'")
        }
        .onAppear {
            if viewModel == nil {
                viewModel = MangaDetailViewModel(collectionVM: collectionVM)
            }
        }
    }

    // MARK: - Private

    private func handleConfirmDelete() async {
        await viewModel?.confirmDelete { manga in
            await collectionVM.remove(manga)
            await MainActor.run {
                if let navigationPath {
                    navigationPath.wrappedValue = NavigationPath()
                } else {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    MangaDetailView(manga: .test, namespace: namespace)
        .withPreviewEnvironment()
}
