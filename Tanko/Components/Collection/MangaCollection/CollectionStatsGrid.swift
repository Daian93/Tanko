//
//  CollectionStatsGrid.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct CollectionStatsGrid: View {
    let stats: UserMangaCollectionViewModel.CollectionStats

    var body: some View {
        HStack {
            StatItem(label: "stat.total",    value: "\(stats.total)",        icon: "books.vertical")
            Divider().frame(height: 40)
            StatItem(label: "stat.reading",  value: "\(stats.reading)",      icon: "book")
            Divider().frame(height: 40)
            StatItem(label: "stat.volumes",    value: "\(stats.volumesOwned)", icon: "square.stack.3d.up")
            Divider().frame(height: 40)
            StatItem(label: "stat.complete",value: "\(stats.complete)",     icon: "checkmark.seal")
        }
        .padding()
        .background(.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10)
        .padding(.horizontal)
    }
}

// MARK: - StatItem

struct StatItem: View {
    let label: LocalizedStringKey
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.tankoPrimary)

            Text(value)
                .font(.headline)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.tankoSecondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CollectionStatsGrid(stats: .init(total: 12, reading: 4, volumesOwned: 87, complete: 3))
}
