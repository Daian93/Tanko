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
    @State private var mainImage: UIImage? = nil
    @State private var backgroundImage: UIImage? = nil
    @State private var isMainLoading = false
    @State private var isBackgroundLoading = false
    @Namespace private var namespace

    let bannerHeight: CGFloat = 200
    let coverOverlap: CGFloat = 80

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: manga.mainPicture) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: bannerHeight).opacity(0.5)
                            .clipped()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }

                    HStack(alignment: .bottom, spacing: 16) {
                        CoverView(
                            cover: manga.mainPicture,
                            namespace: namespace,
                            big: true
                        )
                        .frame(width: 130, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 6)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(manga.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(2)

                            if let titleJapanese = manga.titleJapanese {
                                Text(titleJapanese)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            if let titleEng = manga.titleEnglish {
                                Text(titleEng)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.bottom, 10)

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
                            .foregroundStyle(Color.tankoTextSecondary)

                        Text(manga.formattedScore)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(scoreColor)
                            .accessibilityLabel(
                                "section.score: \(manga.formattedScore)"
                            )
                    }
                    .frame(maxWidth: .infinity)

                    // 📌 Estado
                    VStack(spacing: 4) {
                        Text("section.state")
                            .font(.caption)
                            .foregroundStyle(Color.tankoTextSecondary)

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

                    VStack(spacing: 4) {
                        Text("section.chapters")
                            .font(.caption)
                            .foregroundStyle(Color.tankoTextSecondary)

                        Text(manga.chapters.map(String.init) ?? "—")
                            .font(.headline)
                            .accessibilityLabel(
                                "section.chapters: \(manga.chapters ?? 0)"
                            )
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 4) {
                        Text("section.volumes")
                            .font(.caption)
                            .foregroundStyle(Color.tankoTextSecondary)

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

                    // 👤 Autores
                    VStack(alignment: .leading, spacing: 8) {
                        Text(authorSectionTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text(manga.authorNames)
                            .font(.subheadline)
                            .foregroundStyle(Color.tankoTextSecondary)
                    }
                    .accessibilityLabel(
                        "\(manga.authors.count) section.authors: \(manga.authorNames)"
                    )

                    sectionDivider

                    // 🏷️ Géneros (píldoras)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(genreSectionTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        LazyVGrid(
                            columns: pillColumns,
                            alignment: .leading,
                            spacing: pillSpacing
                        ) {
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

                    sectionDivider

                    VStack(alignment: .leading, spacing: 8) {
                        Text("section.published")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text(manga.publicationYear)
                            .font(.subheadline)
                            .foregroundStyle(Color.tankoTextSecondary)
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

                            LazyVGrid(
                                columns: pillColumns,
                                alignment: .leading,
                                spacing: pillSpacing
                            ) {
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
                    }

                    sectionDivider

                    if !manga.demographicsNames.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(demographicSectionTitle)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            LazyVGrid(
                                columns: pillColumns,
                                alignment: .leading,
                                spacing: pillSpacing
                            ) {
                                ForEach(manga.demographics) { demo in
                                    TagPill(
                                        text: demo.rawValue,
                                        color: .green
                                    )
                                }
                            }
                        }
                        .accessibilityLabel(
                            "\(manga.demographics.count) section.demographics: \(manga.demographicsNames)"
                        )
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 20)

                // Sinopsis
                VStack(alignment: .leading, spacing: 8) {
                    Text("section.synopsis")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(manga.synopsis)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .accessibilityLabel(
                            "section.synopsis: \(manga.synopsis)"
                        )
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayMode(.inline)
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

struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    let content: Content

    init(spacing: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 100), spacing: spacing)],
            alignment: .leading,
            spacing: spacing
        ) {
            content
        }
    }
}

#Preview {
    MangaDetailView(manga: .test)
}
