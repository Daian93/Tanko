//
//  ProgressSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

private var progressSection: some View {
    VStack(alignment: .leading, spacing: 6) {
        HStack {
            Text("Progreso")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(hasDynamicTotal ? "\(reading)+" : "\(reading)/\(displayTotal)")
                .font(.caption.weight(.medium))
                .foregroundStyle(progressColor)
        }

        ProgressView(
            value: hasDynamicTotal
                ? min(Double(reading) / Double(displayTotal), 1.0)
                : Double(safeReading),
            total: Double(safeTotal)
        )
        .tint(progressColor)
        .scaleEffect(y: 2.2)
        .animation(.easeInOut, value: progress)
    }
}
