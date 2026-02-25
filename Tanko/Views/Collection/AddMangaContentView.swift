//
//  AddMangaContentView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct AddMangaContentView: View {
    @Binding var volumesOwned: Set<Int>
    @Binding var readingVolume: Int
    @FocusState.Binding var isTextFieldFocused: Bool
    let totalVolumes: Int
    let maxVolume: Int
    let isCompleteCollection: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                sections(usingCardStyle: true)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.surface)
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
                totalVolumes: totalVolumes
            )
        }

        if totalVolumes > 0 {
            AdaptiveSectionContainer(
                title: "volume.title",
                style: usingCardStyle ? .card : .form
            ) {
                VolumesContent(
                    volumesOwned: $volumesOwned,
                    totalVolumes: totalVolumes
                )
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
    @Previewable @State var volumesOwned: Set<Int> = [1, 2]
    @Previewable @State var readingVolume: Int = 2
    @Previewable @FocusState var isFocused: Bool

    AddMangaContentView(
        volumesOwned: $volumesOwned,
        readingVolume: $readingVolume,
        isTextFieldFocused: $isFocused,
        totalVolumes: 10,
        maxVolume: 10,
        isCompleteCollection: false
    )
}
