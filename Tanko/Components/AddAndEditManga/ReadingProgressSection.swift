//
//  ReadingProgressSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct ReadingProgressSection: View {
    @Binding var readingVolume: Int
    let maxVolume: Int
    @FocusState.Binding var isTextFieldFocused: Bool

    let totalVolumes: Int

    var body: some View {
        SectionContainer(
            title: "reading.title",
            footer: totalVolumes > 0
                ? "reading.footer.one \(totalVolumes)"
                : "reading.footer.two"
        ) {
            ReadingProgressEditor(
                readingVolume: $readingVolume,
                maxVolume: maxVolume,
                isTextFieldFocused: $isTextFieldFocused
            )
        }
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool

    ReadingProgressSection(
        readingVolume: .constant(5),
        maxVolume: 10,
        isTextFieldFocused: $isFocused,
        totalVolumes: 12
    )
}
