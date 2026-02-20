//
//  MangaDetailView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

private let pillSpacing: CGFloat = 8

private let pillColumns: [GridItem] = [
    GridItem(.flexible(), spacing: pillSpacing),
    GridItem(.flexible(), spacing: pillSpacing),
    GridItem(.flexible(), spacing: pillSpacing),
]

struct MangaDetailView: View {
    let manga: Manga
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM

    @State private var mainImage: PlatformImage? = nil
    @State private var backgroundImage: PlatformImage? = nil

    @State private var isMainLoading = false
    @State private var isBackgroundLoading = false
    @State private var isSynopsisExpanded = false
    @State private var isBackgroundExpanded = false
    @State private var showAddSheet = false

    private var isInCollection: Bool {
        collectionVM.isInCollection(mangaID: manga.id)
    }

    let namespace: Namespace.ID?

    let bannerHeight: CGFloat = 200
    let coverOverlap: CGFloat = 80

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: manga.mainPicture) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: bannerHeight)
                                .opacity(0.5)
                                .clipped()
                        } else {
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        .gray.opacity(0.2), .gray.opacity(0.4),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                Image(systemName: "book.closed")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            .frame(height: bannerHeight)
                            .clipped()
                        }
                    }

                    HStack(alignment: .bottom, spacing: 16) {
                        CoverView(
                            cover: manga.mainPicture,
                            namespace: namespace,
                            big: true
                        )
                        .frame(width: 120, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 6)

                        VStack(alignment: .leading, spacing: 1) {
                            Text(manga.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.70)

                            if let titleJapanese = manga.titleJapanese {
                                Text(titleJapanese)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }

                            if let titleEng = manga.titleEnglish {
                                Text(titleEng)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .frame(height: 90, alignment: .bottom)

                        Spacer()
                    }
                    .padding(.horizontal)
                    .offset(y: coverOverlap)
                }

                Spacer(minLength: 100)

                HStack {

                    VStack(spacing: 4) {
                        Text("section.score")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)

                        Text(manga.formattedScore)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(scoreColor)
                            .accessibilityLabel(
                                "section.score: \(manga.formattedScore)"
                            )
                    }
                    .frame(maxWidth: .infinity)

                    Divider().frame(height: 45)

                    // Estado
                    VStack(spacing: 4) {
                        Text("section.state")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)

                        Text(manga.status.localized)
                            .font(.headline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .foregroundStyle(manga.status.color)
                            .accessibilityLabel(
                                "section.state: \(manga.status.localizedKey)"
                            )
                    }
                    .frame(maxWidth: .infinity)

                    Divider().frame(height: 45)

                    VStack(spacing: 4) {
                        Text("section.chapters")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)

                        Text(manga.chapters.map(String.init) ?? "—")
                            .font(.headline)
                            .accessibilityLabel(
                                "section.chapters: \(manga.chapters ?? 0)"
                            )
                    }
                    .frame(maxWidth: .infinity)

                    Divider().frame(height: 45)

                    VStack(spacing: 4) {
                        Text("section.volumes")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)

                        Text(manga.volumes.map(String.init) ?? "—")
                            .font(.headline)
                            .accessibilityLabel(
                                "section.volumes: \(manga.volumes ?? 0)"
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                Spacer(minLength: 20)

                VStack(alignment: .leading, spacing: 15) {

                    // Autores
                    VStack(alignment: .leading, spacing: 8) {
                        Text(authorSectionTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        FlowLayout(spacing: 8) {
                            ForEach(manga.authors) { author in
                                NavigationLink(value: author) {
                                    HStack(spacing: 6) {
                                        Text(author.fullName)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundStyle(
                                                AppColors.textSecondary
                                            )

                                        Image(systemName: author.role.icon)
                                            .font(
                                                .system(size: 8, weight: .bold)
                                            )
                                            .foregroundStyle(.white)
                                            .frame(width: 18, height: 18)
                                            .background(
                                                AppColors.primary.gradient
                                            )
                                            .clipShape(Circle())
                                    }
                                    .padding(.leading, 4)
                                    .padding(.trailing, 2)
                                    .padding(.vertical, 4)
                                    .background(AppColors.primary.opacity(0.1))
                                    .clipShape(Capsule())
                                }

                            }
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(
                        "\(manga.authors.count) section.authors: \(manga.authorNames)"
                    )

                    sectionDivider

                    if !manga.genreNames.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(genreSectionTitle)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            FlowLayout(spacing: pillSpacing) {
                                ForEach(manga.genres) { genre in
                                    TagPill(
                                        text: genre.rawValue,
                                        color: .blue
                                    )
                                }
                            }
                        }
                        .accessibilityLabel(
                            "\(manga.genres.count) section.genres: \(manga.genreNames)"
                        )
                    } else {
                        Text(genreSectionTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("-")
                    }

                    sectionDivider

                    VStack(alignment: .leading, spacing: 8) {
                        Text("section.published")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text(manga.publicationYear)
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .accessibilityLabel(
                        "section.published: \(manga.publicationYear)"
                    )

                    if !manga.themeNames.isEmpty
                        || !manga.demographicsNames.isEmpty
                    {
                        sectionDivider
                    }

                    if !manga.themeNames.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(themeSectionTitle)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            FlowLayout(spacing: pillSpacing) {
                                ForEach(manga.themes) { theme in
                                    TagPill(
                                        text: theme.rawValue,
                                        color: .purple
                                    )
                                }
                            }
                        }
                        .accessibilityLabel(
                            "\(manga.themes.count) section.themes: \(manga.themeNames)"
                        )
                    } else {
                        Text(themeSectionTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("-")
                    }

                    sectionDivider

                    if !manga.demographicsNames.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(demographicSectionTitle)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            FlowLayout(spacing: pillSpacing) {
                                ForEach(manga.demographics) { demographic in
                                    TagPill(
                                        text: demographic.rawValue,
                                        color: .green
                                    )
                                }
                            }
                        }
                        .accessibilityLabel(
                            "\(manga.demographics.count) section.demographics: \(manga.demographicsNames)"
                        )
                    } else {
                        Text(demographicSectionTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("-")
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 20)

                // Sinopsis
                VStack(alignment: .leading, spacing: 12) {
                    Text("section.synopsis")
                        .font(.title3)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading) {
                        Text(manga.synopsis)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .lineLimit(isSynopsisExpanded ? nil : 4)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityLabel(
                                "section.synopsis: \(manga.synopsis)"
                            )
                    }
                    .overlay(alignment: .bottom) {
                        if !isSynopsisExpanded
                            && (manga.background?.count ?? 0) > 200
                        {
                            LinearGradient(
                                colors: [
                                    .clear,
                                    Color(white: 1.0),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 32)
                            .allowsHitTesting(false)
                        }
                    }
                    .animation(
                        .easeInOut(duration: 0.25),
                        value: isSynopsisExpanded
                    )
                    if let bg = manga.background, bg.count > 200 {
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isSynopsisExpanded.toggle()
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(
                                    isSynopsisExpanded
                                        ? "section.showLess"
                                        : "section.showMore"
                                )
                                .font(.caption)
                                .fontWeight(.semibold)

                                Image(
                                    systemName: isSynopsisExpanded
                                        ? "chevron.up" : "chevron.down"
                                )
                                .font(.caption2)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }

            Spacer(minLength: 20)

            // Background
            VStack(alignment: .leading, spacing: 12) {
                Text("section.background")
                    .font(.title3)
                    .fontWeight(.semibold)

                VStack(alignment: .leading) {
                    Text(manga.background ?? "-")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineLimit(isBackgroundExpanded ? nil : 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityLabel(
                            "section.background: \(manga.background ?? "")"
                        )
                }
                .overlay(alignment: .bottom) {
                    if !isBackgroundExpanded
                        && (manga.background?.count ?? 0) > 200
                    {
                        LinearGradient(
                            colors: [
                                .clear,
                                Color(white: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 32)
                        .allowsHitTesting(false)
                    }
                }
                .animation(
                    .easeInOut(duration: 0.25),
                    value: isBackgroundExpanded
                )
                if let bg = manga.background, bg.count > 200 {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isBackgroundExpanded.toggle()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(
                                isBackgroundExpanded
                                    ? "section.showLess" : "section.showMore"
                            )
                            .font(.caption)
                            .fontWeight(.semibold)

                            Image(
                                systemName: isBackgroundExpanded
                                    ? "chevron.up" : "chevron.down"
                            )
                            .font(.caption2)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)

            if let url = manga.url {
                HStack {
                    Spacer()
                    Link(destination: url) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.body)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundStyle(.white)
                            .background(AppColors.primary.gradient)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
            }

            Spacer(minLength: 20)
        }
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayModeCompatible(.inline)
        .toolbar {
            ToolbarItem(
                placement: CompatibleToolbarItemPlacement.topBarTrailing
                    .placement
            ) {
                Button {
                    toggleBookmark()
                } label: {
                    Image(
                        systemName: isInCollection
                            ? "bookmark.fill" : "bookmark"
                    )
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(
                        isInCollection ? AppColors.primary : .primary
                    )
                }
                .animation(.easeInOut(duration: 0.2), value: isInCollection)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddMangaToCollectionView(manga: manga)
                .environment(collectionVM)
        }
    }

    private func toggleBookmark() {
        if isInCollection {
            if let existing = collectionVM.mangas.first(where: {
                $0.mangaID == manga.id
            }) {
                Task {
                    await collectionVM.remove(existing)
                }
            }
        } else {
            showAddSheet = true
        }
    }

}

extension MangaDetailView {

    var genreSectionTitle: LocalizedStringKey {
        manga.genres.count == 1
            ? "section.genres.one"
            : "section.genres.other"
    }

    var authorSectionTitle: LocalizedStringResource {
        manga.authors.count == 1
            ? "section.authors.one"
            : "section.authors.other"
    }

    var themeSectionTitle: LocalizedStringKey {
        manga.themes.count == 1
            ? "section.themes.one"
            : "section.themes.other"
    }

    var demographicSectionTitle: LocalizedStringKey {
        manga.demographics.count == 1
            ? "section.demographics.one"
            : "section.demographics.other"
    }
}

extension MangaDetailView {
    private var scoreColor: Color {
        switch manga.score {
        case ..<5:
            return .red
        case 5..<8:
            return .orange
        default:
            return .green
        }
    }
}

struct TagPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption)
            .bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

private var sectionDivider: some View {
    Rectangle()
        .fill(.gray.opacity(0.3))
        .frame(height: 1)
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    MangaDetailView(manga: .test, namespace: namespace)
        .withPreviewEnvironment()
}
