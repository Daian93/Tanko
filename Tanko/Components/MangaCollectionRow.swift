//
//  MangaCollectionRow.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI
import SwiftData

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
                    .font(.system(size: 22))
                    .foregroundStyle(.tankoPrimary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .padding(.trailing, 35)
            .padding(.top, 12)
        }
        .animation(.snappy, value: isCollected)
        .alert("Quitar de la colección", isPresented: $showDeleteConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Quitar", role: .destructive) {
                Task {
                    if let userManga = userCollectionVM.mangas.first(where: {
                        $0.mangaID == manga.id
                    }) {
                        await userCollectionVM.removeFromCollection(
                            mangaID: userManga.mangaID
                        )
                        dismiss()
                    }
                }
            }
        } message: {
            Text("¿Estás seguro de que quieres quitar '\(manga.title)' de tu colección?")
        }
    }
}

#Preview {
    MangaCollectionRow(
        manga: .test,
        namespace: Namespace().wrappedValue,
        userCollectionVM: PreviewHelper.makeCollectionVM()
    )
    .withPreviewEnvironment()
    .modelContainer(PreviewHelper.container)
}
