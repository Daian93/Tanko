//
//  MangaDetailMetadata.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct MangaDetailMetadata: View {
    let manga: Manga

    private let pillSpacing: CGFloat = 8

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {

            // Authors
            MetadataSection(title: authorSectionTitle) {
                FlowLayout(spacing: 8) {
                    ForEach(manga.authors) { author in
                        NavigationLink(value: author) {
                            AuthorPill(author: author)
                        }
                    }
                }
            }
            .accessibilityLabel(
                "\(manga.authors.count) section.authors: \(manga.authorNames)"
            )

            SectionDivider()

            // Publication year
            MetadataSection(title: "section.published") {
                Text(manga.publicationYear)
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)
            }
            .accessibilityLabel(Text("section.published: \(manga.publicationYear)"))

            SectionDivider()

            // Genres
            MetadataSection(title: genreSectionTitle) {
                if !manga.genreNames.isEmpty {
                    FlowLayout(spacing: pillSpacing) {
                        ForEach(manga.genres) { genre in
                            TagPill(text: genre.rawValue, color: .blue)
                        }
                    }
                } else {
                    Text("-")
                }
            }
            .accessibilityLabel("\(manga.genres.count) section.genres: \(manga.genreNames)")

            if !manga.themeNames.isEmpty || !manga.demographicsNames.isEmpty {
                SectionDivider()
            }

            // Themes
            MetadataSection(title: themeSectionTitle) {
                if !manga.themeNames.isEmpty {
                    FlowLayout(spacing: pillSpacing) {
                        ForEach(manga.themes) { theme in
                            TagPill(text: theme.rawValue, color: .purple)
                        }
                    }
                } else {
                    Text("-")
                }
            }
            .accessibilityLabel("\(manga.themes.count) section.themes: \(manga.themeNames)")

            SectionDivider()

            // Demographics
            MetadataSection(title: demographicSectionTitle) {
                if !manga.demographicsNames.isEmpty {
                    FlowLayout(spacing: pillSpacing) {
                        ForEach(manga.demographics) { demographic in
                            TagPill(text: demographic.rawValue, color: .green)
                        }
                    }
                } else {
                    Text("-")
                }
            }
            .accessibilityLabel(
                "\(manga.demographics.count) section.demographics: \(manga.demographicsNames)"
            )
        }
        .padding(.horizontal)
        .background(.tankoBackground)
    }

    // MARK: - Computed titles

    private var authorSectionTitle: LocalizedStringResource {
        manga.authors.count == 1 ? "section.authors.one" : "section.authors.other"
    }

    private var genreSectionTitle: LocalizedStringResource {
        manga.genres.count == 1 ? "section.genres.one" : "section.genres.other"
    }

    private var themeSectionTitle: LocalizedStringResource {
        manga.themes.count == 1 ? "section.themes.one" : "section.themes.other"
    }

    private var demographicSectionTitle: LocalizedStringResource {
        manga.demographics.count == 1
            ? "section.demographics.one"
            : "section.demographics.other"
    }
}

// MARK: - MetadataSection

private struct MetadataSection<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder let content: () -> Content

    init(title: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            content()
        }
    }
}

// Overload for LocalizedStringResource
private extension MangaDetailMetadata {
    struct MetadataSectionResource<Content: View>: View {
        let title: LocalizedStringResource
        @ViewBuilder let content: () -> Content

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                content()
            }
        }
    }

    func MetadataSection(
        title: LocalizedStringResource,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        MetadataSectionResource(title: title, content: content)
    }
}

// MARK: - AuthorPill

private struct AuthorPill: View {
    let author: Author

    var body: some View {
        HStack(spacing: 6) {
            Text(author.fullName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.textSecondary)

            Image(systemName: author.role.icon)
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 18, height: 18)
                .background(.tankoPrimary.gradient)
                .clipShape(Circle())
        }
        .padding(.leading, 4)
        .padding(.trailing, 2)
        .padding(.vertical, 4)
        .background(.tankoPrimary.opacity(0.1))
        .clipShape(Capsule())
    }
}

#Preview {
    ScrollView {
        MangaDetailMetadata(manga: .test)
    }
}

