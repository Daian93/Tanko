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
        #if os(macOS)
        ScrollView {
            VStack(spacing: 24) {
                ReadingProgressSection(
                    readingVolume: $readingVolume,
                    maxVolume: maxVolume,
                    isTextFieldFocused: $isTextFieldFocused,
                    totalVolumes: totalVolumes
                )
                if totalVolumes > 0 {
                    VolumesSection(
                        volumesOwned: $volumesOwned,
                        totalVolumes: totalVolumes
                    )
                    CollectionStateSection(
                        volumesOwned: volumesOwned.count,
                        totalVolumes: totalVolumes,
                        isComplete: isCompleteCollection
                    )
                }
            }
            .padding()
        }
        #else
        Form {
            ReadingProgressSection(
                readingVolume: $readingVolume,
                maxVolume: maxVolume,
                isTextFieldFocused: $isTextFieldFocused,
                totalVolumes: totalVolumes
            )
            if totalVolumes > 0 {
                VolumesSection(
                    volumesOwned: $volumesOwned,
                    totalVolumes: totalVolumes
                )
                CollectionStateSection(
                    volumesOwned: volumesOwned.count,
                    totalVolumes: totalVolumes,
                    isComplete: isCompleteCollection
                )
            }
        }
        .scrollDismissesKeyboard(.immediately)
        #endif
    }
}
