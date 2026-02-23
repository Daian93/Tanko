//
//  VolumesSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct VolumesContent: View {
    @Binding var volumesOwned: Set<Int>
    let totalVolumes: Int
    var footer: String? = nil

    var footerText: String {
        footer ?? "\(volumesOwned.count) / \(totalVolumes)"
    }

    var body: some View {
        VStack(spacing: 12) {
            VolumeSelectionGrid(
                volumesOwned: $volumesOwned,
                totalVolumes: totalVolumes
            )

            Text(footerText)
                .font(.caption)
                .foregroundStyle(.tankoSecondary)
        }
    }
}

#Preview {
    @Previewable @State var volumesOwned: Set<Int> = [1, 3, 5]
    VolumesContent(volumesOwned: $volumesOwned, totalVolumes: 10)
}
