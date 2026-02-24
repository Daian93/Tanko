//
//  MangaProgressRow.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct MangaProgressRow: View {
    @Bindable var userManga: UserManga
    let namespace: Namespace.ID

    @Environment(UserMangaCollectionViewModel.self) private var collectionVM
    @State private var showDeleteAlert = false

    // MARK: - Computed

    private var totalVolumes: Int? { userManga.totalVolumes }
    private var hasDynamicTotal: Bool { totalVolumes == nil }
    private var reading: Int { userManga.readingVolume ?? 0 }
    private var displayTotal: Int {
        if let total = totalVolumes { return total }
        return max(reading, userManga.volumesOwned.max() ?? 0, 1)
    }
    private var safeReading: Int { min(reading, displayTotal) }
    private var safeTotal: Int { max(displayTotal, reading, 1) }
    private var progress: Double { Double(safeReading) / Double(safeTotal) }

    private var isFullyRead: Bool {
        guard let total = totalVolumes, total > 0 else { return false }
        return reading >= total
    }

    private var isCompleteCollection: Bool { userManga.completeCollection }

    private var progressColor: Color {
        if isFullyRead { return .green }
        if progress == 0 { return .tankoSecondary }
        if progress < 0.5 { return .tankoPrimary }
        return .orange
    }

    var body: some View {
        NavigationLink(value: userManga) {
            HStack(spacing: 14) {
                CoverView(cover: userManga.coverURL, namespace: namespace, big: false)
                    .frame(width: 70, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 8) {
                    Text(userManga.title)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(2)

                    progressSection
                    badgesRow
                }

                Spacer()
            }
            .padding()
            .background(.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(alignment: .topTrailing) { deleteButton }
        }
        .buttonStyle(.plain)
        .alert(
            "collection.remove",
            isPresented: $showDeleteAlert,
            actions: {
                Button("button.remove", role: .destructive) {
                    Task { await collectionVM.remove(userManga) }
                }
                Button("button.cancel", role: .cancel) {}
            },
            message: {
                Text("collection.remove.text '\(userManga.title)'")
            }
        )
    }

    // MARK: - Subviews

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("progress.title")
                    .font(.caption)
                    .foregroundStyle(.tankoSecondary)
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

    private var badgesRow: some View {
        HStack(spacing: 6) {

            Label("\(userManga.volumesOwned.count) badge.volumes",
                  systemImage: "books.vertical.fill")
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.1))
                .foregroundStyle(.green)
                .clipShape(Capsule())

            if isFullyRead {
                Label("badge.read", systemImage: "book.closed.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue)
            }

            if isCompleteCollection {
                Label("badge.complete", systemImage: "checkmark.seal.fill")
                    .font(.caption2)
                    .foregroundStyle(.green)
            }
        }
    }

    private var deleteButton: some View {
        Button {
            showDeleteAlert = true
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.tankoPrimary)
                .font(.title2)
                .padding(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        MangaProgressRow(userManga: .monster, namespace: namespace)
    }
    .withPreviewEnvironment()
}
