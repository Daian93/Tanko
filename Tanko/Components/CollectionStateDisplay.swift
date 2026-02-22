//
//  CollectionStateDisplay.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI

// MARK: - Collection State Display

struct CollectionStateDisplay: View {
    let volumesOwned: Int
    let totalVolumes: Int
    let isCompleteCollection: Bool
    
    var body: some View {
        HStack {
            Label("Estado de la colección", systemImage: "checkmark.seal.fill")
                .foregroundStyle(.tankoSecondary)
            Spacer()
            if isCompleteCollection {
                Text("Completa")
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            } else {
                Text("Incompleta")
                    .foregroundStyle(.tankoSecondary)
            }
        }
    }
    
    var footerText: String {
        if isCompleteCollection {
            return "Tienes todos los \(totalVolumes) tomos en tu estantería."
        } else {
            return "Te faltan \(totalVolumes - volumesOwned) tomos para completar la colección."
        }
    }
}
