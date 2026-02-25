//
//  ReadingProgressSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct ReadingProgressContent: View {
    @Binding var readingVolume: Int
    let maxVolume: Int
    @FocusState.Binding var isTextFieldFocused: Bool
    var footer: LocalizedStringKey? = nil
    var totalVolumes: Int = 0

    var footerText: LocalizedStringKey {
        if let footer { return footer }
        return totalVolumes > 0 ? "reading.footer.one \(totalVolumes)" : "reading.footer.two"
    }

    var body: some View {
        VStack(spacing: 12) {
            ReadingProgressEditor(
                readingVolume: $readingVolume,
                maxVolume: maxVolume,
                isTextFieldFocused: $isTextFieldFocused
            )

            Text(footerText)
                .font(.caption)
                .foregroundStyle(.tankoSecondary)
        }
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    ReadingProgressContent(
        readingVolume: .constant(5),
        maxVolume: 10,
        isTextFieldFocused: $isFocused,
        totalVolumes: 12
    )
}
