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
    private var isCompleted: Bool { safeReading >= safeTotal }
    private var progressColor: Color {
        if isCompleted { return .green }
        if progress == 0 { return .gray }
        if progress < 0.5 { return .orange }
        return .tankoSecondary
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
            .background(Color("TankoCardSurface"))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
            .overlay(alignment: .topTrailing) { deleteButton }
        }
        .buttonStyle(.plain)
        .alert(
            "Quitar de la colección",
            isPresented: $showDeleteAlert,
            actions: {
                Button("Quitar", role: .destructive) {
                    Task { await collectionVM.remove(userManga) }
                }
                Button("Cancelar", role: .cancel) {}
            },
            message: {
                Text("¿Estás seguro de que quieres quitar '\(userManga.title)' de tu colección?")
            }
        )
    }

    // MARK: - Subviews

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

    private var badgesRow: some View {
        HStack {
            Label("\(userManga.volumesOwned.count) tomos", systemImage: "books.vertical.fill")
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.1))
                .foregroundStyle(.green)
                .clipShape(Capsule())

            if isCompleted {
                Label("Completo", systemImage: "checkmark.seal.fill")
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
