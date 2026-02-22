//
//  VolumesSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct VolumesSection: View {
    @Binding var volumesOwned: Set<Int>
    let totalVolumes: Int

    var body: some View {
        SectionContainer(
            title: "volume.title",
            footer: "\(volumesOwned.count) \(totalVolumes) volume.footer"
        ) {
            VolumeSelectionGrid(
                volumesOwned: $volumesOwned,
                totalVolumes: totalVolumes
            )
        }
    }
}

#Preview {
    @Previewable @State var volumesOwned: Set<Int> = [1, 3, 5]
    VolumesSection(volumesOwned: $volumesOwned, totalVolumes: 10)
}
