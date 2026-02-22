//
//  UserMangaDetailView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftData
import SwiftUI

struct UserMangaDetailView: View {

    // MARK: - Properties

    @State private var viewModel: UserMangaDetailViewModel
    let namespace: Namespace.ID
    @Binding var navigationPath: NavigationPath
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - Initialization

    init(
        userManga: UserManga,
        collectionVM: UserMangaCollectionViewModel,
        namespace: Namespace.ID,
        navigationPath: Binding<NavigationPath>
    ) {
        self.viewModel = UserMangaDetailViewModel(
            userManga: userManga,
            collectionVM: collectionVM
        )
        self.namespace = namespace
        self._navigationPath = navigationPath
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // MARK: Header
                UserMangaDetailHeader(
                    coverURL: viewModel.userManga.coverURL,
                    title: viewModel.userManga.title,
                    namespace: namespace
                )
                .padding(.horizontal)
                .padding(.top, 8)

                // MARK: Progreso de lectura
                VStack(alignment: .leading, spacing: 12) {
                    Text("Progreso de lectura")
                        .font(.headline)
                        .padding(.horizontal)

                    ReadingProgressEditor(
                        readingVolume: $viewModel.readingVolume,
                        maxVolume: viewModel.maxVolume,
                        isTextFieldFocused: $isTextFieldFocused
                    )
                    .padding()
                    .backgroundStyle(.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
                    .padding(.horizontal)
                    .onChange(of: viewModel.readingVolume) { _, _ in
                        viewModel.saveChanges()
                    }

                    Text(viewModel.totalVolumesFooterText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }

                // MARK: Tomos en estantería
                if viewModel.totalVolumes > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tomos en estantería")
                            .font(.headline)
                            .padding(.horizontal)

                        VolumeSelectionGrid(
                            volumesOwned: $viewModel.volumesOwned,
                            totalVolumes: viewModel.totalVolumes
                        )
                        .padding()
                        .backgroundStyle(.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
                        .padding(.horizontal)
                        .onChange(of: viewModel.volumesOwned) { _, _ in
                            viewModel.saveChanges()
                        }

                        Text(viewModel.volumesSelectionFooterText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                }

                // MARK: Estado de colección
                if viewModel.shouldShowCollectionState {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Estado de la colección")
                            .font(.headline)
                            .padding(.horizontal)

                        let stateDisplay = CollectionStateDisplay(
                            volumesOwned: viewModel.volumesOwned.count,
                            totalVolumes: viewModel.totalVolumes,
                            isCompleteCollection: viewModel.isCompleteCollection
                        )

                        stateDisplay
                            .padding()
                            .backgroundStyle(.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: .black.opacity(0.05),
                                radius: 8,
                                y: 3
                            )
                            .padding(.horizontal)

                        Text(stateDisplay.footerText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                }

                // MARK: Enlace a Detalle General
                VStack(alignment: .leading, spacing: 12) {
                    Text("Información de la obra")
                        .font(.headline)
                        .padding(.horizontal)

                    NavigationLink(value: viewModel.userManga.mangaID)  {
                        HStack {
                            Label(
                                "Ver ficha del manga",
                                systemImage: "info.circle.fill"
                            )
                            .font(.subheadline.bold())

                            Spacer()

                            if viewModel.isLoadingManga {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else if viewModel.manga == nil {
                                Image(systemName: "arrow.clockwise")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                            } else {
                                Image(systemName: "chevron.right")
                                    .font(.caption.bold())
                                    .foregroundStyle(.tankoSecondary)
                            }
                        }
                        .foregroundStyle(
                            viewModel.manga != nil
                            ? .tankoPrimary : .tankoSecondary
                        )
                        .padding()
                        .backgroundStyle(.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                    .task {
                        await viewModel.loadManga()
                    }

                    Text(
                        "Consulta la sinopsis, géneros y otros detalles técnicos."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Editar manga")
        .navigationBarTitleDisplayModeCompatible(.inline)
        .navigationDestination(for: Int.self) { mangaID in
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

// MARK: - Preview

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
