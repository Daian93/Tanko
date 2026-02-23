//
//  ProfileStatsSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct ProfileStatsSection: View {
    let stats: UserMangaCollectionViewModel.CollectionStats

    private var readingPercent: Double {
        guard stats.total > 0 else { return 0 }
        return Double(stats.reading) / Double(stats.total)
    }

    private var completePercent: Double {
        guard stats.total > 0 else { return 0 }
        return Double(stats.complete) / Double(stats.total)
    }

    var body: some View {
        if stats.total > 0 {
            VStack(spacing: 16) {
                ProgressRow(
                    label: "stats.progress.reading",
                    percent: readingPercent,
                    color: .blue
                )

                ProgressRow(
                    label: "stats.progress.complete",
                    percent: completePercent,
                    color: .orange
                )
            }
            .padding(.vertical, 8)
        } else {
            Text("stats.empty")
                .font(.caption)
                .foregroundStyle(.tankoSecondary)
                .padding(.vertical, 8)
        }
    }
}

private struct ProgressRow: View {
    let label: LocalizedStringKey
    let percent: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.tankoSecondary)
                Spacer()
                Text("\(Int(percent * 100))%")
                    .font(.caption.bold())
                    .foregroundStyle(color)
            }
            ProgressView(value: percent)
                .tint(color)
                .scaleEffect(y: 1.2)
        }
    }
}

#Preview {
    let stats = UserMangaCollectionViewModel.CollectionStats(
        total: 20,
        reading: 8,
        volumesOwned: 45,
        complete: 5
    )
    List {
        ProfileStatsSection(stats: stats)
    }
}
