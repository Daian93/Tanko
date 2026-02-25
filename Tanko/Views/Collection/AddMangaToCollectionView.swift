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
    @Environment(AppSettings.self) private var settings

    @State private var viewModel: AddMangaViewModel?
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            if let vm = viewModel {
                @Bindable var bvm = vm
                AddMangaContentView(
                    volumesOwned: $bvm.volumesOwned,
                    readingVolume: $bvm.readingVolume,
                    isTextFieldFocused: $isTextFieldFocused,
                    totalVolumes: vm.totalVolumes,
                    maxVolume: vm.maxVolume,
                    isCompleteCollection: vm.isCompleteCollection
                )
                .navigationTitle("collection.add")
                .navigationBarTitleDisplayModeCompatible(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("button.cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            Task {
                                await vm.addToCollection()
                                dismiss()
                            }
                        } label: {
                            HStack(spacing: 4) {
                                if vm.isAdding {
                                    ProgressView().scaleEffect(0.8)
                                }
                                Text("button.add")
                            }
                        }
                        .disabled(vm.isAdding)
                    }
                }
                .background(.tankoBackground)
            }
        }
        .id(settings.appLanguage)
        .onAppear {
            viewModel = AddMangaViewModel(
                manga: manga,
                collectionVM: collectionVM
            )
        }
    }
}

#Preview {
    AddMangaToCollectionView(manga: .test)
        .withPreviewEnvironment()
}
