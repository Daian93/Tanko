//
//  CollectionStateSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct CollectionStateSection: View {
    let volumesOwned: Int
    let totalVolumes: Int
    let isComplete: Bool

    var body: some View {
        let state = CollectionStateDisplay(
            volumesOwned: volumesOwned,
            totalVolumes: totalVolumes,
            isCompleteCollection: isComplete
        )
        return SectionContainer(
            title: "collection.state",
            footer: state.footerText
        ) {
            state
        }
    }
}

#Preview {
    CollectionStateSection(
        volumesOwned: 5,
        totalVolumes: 10,
        isComplete: false
    )
}
