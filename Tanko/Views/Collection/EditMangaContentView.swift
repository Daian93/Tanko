//
//  EditMangaContentView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct EditMangaContentView: View {
    @Binding var volumesOwned: Set<Int>
    @Binding var readingVolume: Int
    @FocusState.Binding var isTextFieldFocused: Bool

    let totalVolumes: Int
    let maxVolume: Int
    let isCompleteCollection: Bool
    let onSave: () -> Void
    let infoLink: () -> MangaInfoLink

    var readingFooter: LocalizedStringKey? = nil
    var volumesFooter: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                sections(usingCardStyle: true)

                infoLink()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.tankoBackground)
    }

    // MARK: - Shared Sections
    @ViewBuilder
    private func sections(usingCardStyle: Bool) -> some View {
        AdaptiveSectionContainer(
            title: "reading.title",
            style: usingCardStyle ? .card : .form
        ) {
            ReadingProgressContent(
                readingVolume: $readingVolume,
                maxVolume: maxVolume,
                isTextFieldFocused: $isTextFieldFocused,
                footer: readingFooter,
                totalVolumes: totalVolumes
            )
            .onChange(of: readingVolume) { _, _ in onSave() }
        }

        if totalVolumes > 0 {
            AdaptiveSectionContainer(
                title: "volume.title",
                style: usingCardStyle ? .card : .form
            ) {
                VolumesContent(
                    volumesOwned: $volumesOwned,
                    totalVolumes: totalVolumes,
                    footer: volumesFooter
                )
                .onChange(of: volumesOwned) { _, _ in onSave() }
            }

            AdaptiveSectionContainer(
                title: "collection.state",
                style: usingCardStyle ? .card : .form
            ) {
                CollectionStateContent(
                    volumesOwned: volumesOwned.count,
                    totalVolumes: totalVolumes,
                    isComplete: isCompleteCollection
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var volumesOwned: Set<Int> = [1, 2, 3]
    @Previewable @State var readingVolume: Int = 2
    @Previewable @FocusState var isFocused: Bool

    let testVM = UserMangaDetailViewModel(
        userManga: .monster,
        collectionVM: PreviewHelper.makeCollectionVM()
    )

    EditMangaContentView(
        volumesOwned: $volumesOwned,
        readingVolume: $readingVolume,
        isTextFieldFocused: $isFocused,
        totalVolumes: 10,
        maxVolume: 10,
        isCompleteCollection: false,
        onSave: {},
        infoLink: {
            MangaInfoLink(viewModel: testVM)
        }
    )
}
