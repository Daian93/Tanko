//
//  CollectionStateDisplay.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI

struct CollectionStateDisplay: View {
    let volumesOwned: Int
    let totalVolumes: Int
    let isCompleteCollection: Bool
    
    var body: some View {
        HStack {
            Label("collection.state", systemImage: "checkmark.seal.fill")
                .foregroundStyle(.tankoSecondary)
            Spacer()
            if isCompleteCollection {
                Text("collection.complete")
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            } else {
                Text("collection.incomplete")
                    .foregroundStyle(.tankoSecondary)
            }
        }
    }
    
    // Footer text showing how many volumes are owned vs total
    var footerText: LocalizedStringKey {
        if isCompleteCollection {
            return "collection.all.volumes.owned \(totalVolumes)"
        } else {
            return "collection.not.all.volumes.owned \(totalVolumes - volumesOwned)"
        }
    }
}


