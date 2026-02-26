//
//  MangaCardWidget.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import SwiftUI
import WidgetKit

struct MangaCardWidget: View {
    let manga: ReadingManga

    var body: some View {
        Link(destination: URL(string: "tanko://manga/\(manga.id)")!) {
            ZStack(alignment: .topTrailing) {

                // MARK: - Background Cover
                GeometryReader { geo in
                    if let image = WidgetImageCache.loadCover(
                        from: manga.coverURL
                    ) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: geo.size.width,
                                height: geo.size.height
                            )
                            .clipped()
                            .widgetAccentable()
                    } else {
                        placeholderView
                            .widgetAccentable()
                    }
                }

                // MARK: - Bottom Shadow Gradient
                bottomGradient

                // MARK: - Info Section
                infoSection

                // MARK: - Progress Badge
                if manga.progress > 0 {
                    progressBadge
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: WidgetTheme.Size.borderRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: WidgetTheme.Size.borderRadius)
                    .strokeBorder(
                        .primary.opacity(0.1),
                        lineWidth: WidgetTheme.Size.borderWidth
                    )
            )
        }
    }

    // MARK: - Subviews

    private var placeholderView: some View {
        Color.gray.opacity(0.2)
            .overlay(
                Image(systemName: "book.closed.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            )
    }

    private var bottomGradient: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.8),
                .black.opacity(0.4),
                .clear,
            ],
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer()

            Text(manga.title)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .widgetAccentable()

            progressBar

            Text(manga.progressText)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
                .widgetAccentable()
        }
        .padding(WidgetTheme.Spacing.cardPadding)
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.white.opacity(0.2))
                    .frame(height: WidgetTheme.Size.progressBarHeight)

                Capsule()
                    .fill(WidgetTheme.progressColor(for: manga.progress))
                    .frame(
                        width: geometry.size.width * manga.progress,
                        height: WidgetTheme.Size.progressBarHeight
                    )
                    .widgetAccentable()
            }
        }
        .frame(height: WidgetTheme.Size.progressBarHeight)
    }

    private var progressBadge: some View {
        Text("\(Int(manga.progress * 100))%")
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(WidgetTheme.progressColor(for: manga.progress))
            )
            .padding(WidgetTheme.Spacing.badgePadding)
            .widgetAccentable()
    }
}
