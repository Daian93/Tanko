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
        modelContext: ModelContext,
        namespace: Namespace.ID,
        navigationPath: Binding<NavigationPath>
    ) {
        self.namespace = namespace
        self._navigationPath = navigationPath
        _viewModel = State(initialValue: UserMangaDetailViewModel(
            userManga: userManga,
            collectionVM: collectionVM,
            modelContext: modelContext
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                UserMangaDetailHeader(
                    coverURL: viewModel.userManga.coverURL,
                    title: viewModel.userManga.title,
                    namespace: namespace
                )
                .padding(.horizontal)
                .padding(.top, 8)

                EditMangaContentView(
                    volumesOwned: $viewModel.volumesOwned,
                    readingVolume: $viewModel.readingVolume,
                    isTextFieldFocused: $isTextFieldFocused,
                    totalVolumes: viewModel.totalVolumes,
                    maxVolume: viewModel.maxVolume,
                    isCompleteCollection: viewModel.isCompleteCollection,
                    onSave: { viewModel.saveChanges() },
                    infoLink: { MangaInfoLink(viewModel: viewModel) },
                    readingFooter: viewModel.readingProgressFooter,
                    volumesFooter: viewModel.volumesFooter
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
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var path = NavigationPath()
    let collectionVM = PreviewHelper.makeCollectionVM()
    let modelContext = PreviewHelper.makeModelContext()

    NavigationStack {
        UserMangaDetailView(
            userManga: .monster,
            collectionVM: collectionVM,
            modelContext: modelContext,
            namespace: namespace,
            navigationPath: $path
        )
    }
    .withPreviewEnvironment()
}
