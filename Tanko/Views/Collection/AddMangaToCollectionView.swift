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
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM

    @State private var volumesOwned: Set<Int> = []
    @State private var readingVolume: Int = 0
    @State private var isAdding = false

    @FocusState private var isTextFieldFocused: Bool

    private var totalVolumes: Int {
        max(manga.volumes ?? 0, 0)
    }

    private var maxVolume: Int {
        totalVolumes > 0 ? totalVolumes : 999
    }

    private var isCompleteCollection: Bool {
        totalVolumes > 0 && volumesOwned.count == totalVolumes
    }

    var body: some View {
        NavigationStack {
            AddMangaContentView(
                volumesOwned: $volumesOwned,
                readingVolume: $readingVolume,
                isTextFieldFocused: $isTextFieldFocused,
                totalVolumes: totalVolumes,
                maxVolume: maxVolume,
                isCompleteCollection: isCompleteCollection
            )
            .navigationTitle("collection.add")
            .navigationBarTitleDisplayModeCompatible(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("button.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        guard !isAdding else { return }
                        isAdding = true
                        Task {
                            await collectionVM.add(
                                manga: manga,
                                volumesOwned: Array(volumesOwned).sorted(),
                                readingVolume: readingVolume == 0 ? nil : readingVolume,
                                completeCollection: isCompleteCollection
                            )
                            dismiss()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            if isAdding { ProgressView().scaleEffect(0.8) }
                            Text("button.add")
                        }
                    }
                    .disabled(isAdding)
                }
            }
        }
    }
}

#Preview {
    AddMangaToCollectionView(manga: .test)
        .withPreviewEnvironment()
}
