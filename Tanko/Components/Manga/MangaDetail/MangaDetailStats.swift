//
//  MangaDetailStats.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct MangaDetailStats: View {
    let manga: Manga

    var body: some View {
        HStack {
            StatColumn(
                label: "section.score",
                value: manga.formattedScore,
                valueColor: scoreColor
            )

            Divider().frame(height: 45)

            StatColumn(
                label: "section.state",
                value: manga.status.localized,
                valueColor: manga.status.color
            )

            Divider().frame(height: 45)

            StatColumn(
                label: "section.chapters",
                value: manga.chapters.map(String.init) ?? "—"
            )

            Divider().frame(height: 45)

            StatColumn(
                label: "section.volumes",
                value: manga.volumes.map(String.init) ?? "—"
            )
        }
        .padding()
        .background(.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var scoreColor: Color {
        switch manga.score {
        case ..<5:   return .red
        case 5..<8:  return .orange
        default:     return .green
        }
    }
}

// MARK: - StatColumn

private struct StatColumn: View {
    let label: LocalizedStringKey
    let value: LocalizedStringKey
    var valueColor: Color = .primary

    // Convenience init for String values
    init(label: LocalizedStringKey, value: String, valueColor: Color = .primary) {
        self.label = label
        self.value = LocalizedStringKey(value)
        self.valueColor = valueColor
    }

    // Init for LocalizedStringKey values
    init(label: LocalizedStringKey, value: LocalizedStringKey, valueColor: Color = .primary) {
        self.label = label
        self.value = value
        self.valueColor = valueColor
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.textSecondary)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MangaDetailStats(manga: .test)
}
