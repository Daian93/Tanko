//
//  UserMangaDetailView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI
import SwiftData

struct UserMangaDetailView: View {
    @State private var viewModel: UserMangaDetailViewModel
    let namespace: Namespace.ID
    @Binding var navigationPath: NavigationPath
    @FocusState private var isTextFieldFocused: Bool

    init(
        userManga: UserManga,
        collectionVM: UserMangaCollectionViewModel,
        namespace: Namespace.ID,
        navigationPath: Binding<NavigationPath>
    ) {
        self.viewModel = UserMangaDetailViewModel(userManga: userManga, collectionVM: collectionVM)
        self.namespace = namespace
        self._navigationPath = navigationPath
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with cover and title
                UserMangaDetailHeader(
                    coverURL: viewModel.userManga.coverURL,
                    title: viewModel.userManga.title,
                    namespace: namespace
                )
                .padding(.horizontal)
                .padding(.top, 8)

                // Editable content
                EditMangaContentView(
                    volumesOwned: $viewModel.volumesOwned,
                    readingVolume: $viewModel.readingVolume,
                    isTextFieldFocused: $isTextFieldFocused,
                    totalVolumes: viewModel.totalVolumes,
                    maxVolume: viewModel.maxVolume,
                    isCompleteCollection: viewModel.isCompleteCollection,
                    onSave: { viewModel.saveChanges() },
                    infoLink: { MangaInfoLink(viewModel: viewModel) }
                )
            }
        }
        .background(.tankoBackground)
        .navigationTitle("detail.title")
        .navigationBarTitleDisplayModeCompatible(.inline)
        .navigationDestination(for: Int.self) { _ in
            if let manga = viewModel.manga {
                MangaDetailView(
                    manga: manga,
                    namespace: nil,
                    navigationPath: $navigationPath
                )
            }
        }
        .navigationDestination(for: Author.self) { author in
            #if os(macOS)
            AuthorMangaViewiPad(author: author)
            #else
            if UIDevice.current.userInterfaceIdiom == .pad {
                AuthorMangaViewiPad(author: author)
            } else {
                AuthorMangaView(author: author)
            }
            #endif
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var path = NavigationPath()
    let collectionVM = PreviewHelper.makeCollectionVM()

    NavigationStack(path: $path) {
        UserMangaDetailView(
            userManga: .monster,
            collectionVM: collectionVM,
            namespace: namespace,
            navigationPath: $path
        )
    }
    .withPreviewEnvironment()
}
