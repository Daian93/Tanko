//
//  AddMangaToCollectionView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 8/2/26.
//

import SwiftData
import SwiftUI

struct AddMangaToCollectionView: View {
    let manga: Manga

    @Environment(\.dismiss) private var dismiss
    @Environment(UserMangaCollectionViewModel.self) private
        var userMangaCollectionVM

    @State private var volumesOwned: Set<Int> = []
    @State private var readingVolume: Int = 0
    @State private var isAdding: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    private var totalVolumes: Int {
        max(manga.volumes ?? 0, 0)
    }

    private var maxVolume: Int {
        totalVolumes > 0 ? totalVolumes : 999
    }

    private var isCompleteCollection: Bool {
        guard totalVolumes > 0 else { return false }
        return volumesOwned.count == totalVolumes
    }

    var body: some View {
        NavigationStack {
            Group {
                #if os(macOS)
                    ScrollView {
                        VStack(spacing: 20) {
                            progressSection
                            if totalVolumes > 0 {
                                volumesSection
                                collectionStateSection
                            }
                        }
                        .padding()
                    }
                #else
                    Form {
                        progressSection
                        if totalVolumes > 0 {
                            volumesSection
                            collectionStateSection
                        }
                    }
                    .scrollDismissesKeyboard(.immediately)
                #endif
            }
            .navigationTitle("Añadir a colección")
            .navigationBarTitleDisplayModeCompatible(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Añadir") {
                        guard !isAdding else { return }
                        isAdding = true
                        
                        Task {
                            await userMangaCollectionVM.add(
                                manga: manga,
                                volumesOwned: Array(volumesOwned).sorted(),
                                readingVolume: readingVolume == 0
                                    ? nil : readingVolume,
                                completeCollection: isCompleteCollection
                            )
                            dismiss()
                        }
                    }
                    .disabled(isAdding)
                }
            }
        }

    }

    // MARK: - Section Views

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            #if os(macOS)
                Text("Progreso de lectura")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                ReadingProgressEditor(
                    readingVolume: $readingVolume,
                    maxVolume: maxVolume,
                    isTextFieldFocused: $isTextFieldFocused
                )
                .padding()
                .background(Color(white: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                if totalVolumes > 0 {
                    Text("De un total de \(totalVolumes) tomos.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Total de volúmenes desconocido.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            #else
                Section {
                    ReadingProgressEditor(
                        readingVolume: $readingVolume,
                        maxVolume: maxVolume,
                        isTextFieldFocused: $isTextFieldFocused
                    )
                } header: {
                    Text("Progreso de lectura")
                } footer: {
                    if totalVolumes > 0 {
                        Text("De un total de \(totalVolumes) tomos.")
                    } else {
                        Text("Total de volúmenes desconocido.")
                    }
                }
            #endif
        }
    }

    private var volumesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            #if os(macOS)
                Text("Tomos en estantería")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                VolumeSelectionGrid(
                    volumesOwned: $volumesOwned,
                    totalVolumes: totalVolumes
                )
                .padding()
                .background(Color(white: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("\(volumesOwned.count) de \(totalVolumes) tomos seleccionados")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            #else
                Section {
                    VolumeSelectionGrid(
                        volumesOwned: $volumesOwned,
                        totalVolumes: totalVolumes
                    )
                } header: {
                    Text("Tomos en estantería")
                } footer: {
                    Text("\(volumesOwned.count) de \(totalVolumes) tomos seleccionados")
                }
            #endif
        }
    }

    private var collectionStateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            #if os(macOS)
                Text("Estado de la colección")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                CollectionStateDisplay(
                    volumesOwned: volumesOwned.count,
                    totalVolumes: totalVolumes,
                    isCompleteCollection: isCompleteCollection
                )
                .padding()
                .background(Color(white: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                let stateDisplay = CollectionStateDisplay(
                    volumesOwned: volumesOwned.count,
                    totalVolumes: totalVolumes,
                    isCompleteCollection: isCompleteCollection
                )
                Text(stateDisplay.footerText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            #else
                Section {
                    CollectionStateDisplay(
                        volumesOwned: volumesOwned.count,
                        totalVolumes: totalVolumes,
                        isCompleteCollection: isCompleteCollection
                    )
                } footer: {
                    let stateDisplay = CollectionStateDisplay(
                        volumesOwned: volumesOwned.count,
                        totalVolumes: totalVolumes,
                        isCompleteCollection: isCompleteCollection
                    )
                    Text(stateDisplay.footerText)
                }
            #endif
        }
    }
}

#Preview {
    AddMangaToCollectionView(manga: .test)
        .withPreviewEnvironment()
}
