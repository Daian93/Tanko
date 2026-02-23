//
//  CollectionStateSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct CollectionStateContent: View {
    let volumesOwned: Int
    let totalVolumes: Int
    let isComplete: Bool

    private var stateDisplay: CollectionStateDisplay {
        CollectionStateDisplay(
            volumesOwned: volumesOwned,
            totalVolumes: totalVolumes,
            isCompleteCollection: isComplete
        )
    }

    var body: some View {
        VStack(spacing: 8) {
            stateDisplay

            Text(stateDisplay.footerText)
                .font(.caption)
                .foregroundStyle(.tankoSecondary)
        }
    }
}

#Preview {
    CollectionStateContent(
        volumesOwned: 5,
        totalVolumes: 10,
        isComplete: false
    )
}
