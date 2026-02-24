//
//  MangaDetailMetadata.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct MangaDetailMetadata: View {
    let manga: Manga

    @State private var router = NavigationRouter.shared

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
            .accessibilityLabel(
                Text("section.published: \(manga.publicationYear)")
            )

            SectionDivider()

            // Genres
            MetadataSection(title: genreSectionTitle) {
                if !manga.genres.isEmpty {
                    FlowLayout(spacing: pillSpacing) {
                        ForEach(manga.genres) { genre in
                            FilterablePill(text: genre.localized, color: .blue) {
                                router.navigateToSearch(
                                    filter: CustomSearchDTO(
                                        genres: [genre.rawValue],
                                        contains: true
                                    )
                                )
                            }
                        }
                    }
                } else {
                    Text("-")
                }
            }
            .accessibilityLabel(
                "\(manga.genres.count) section.genres: \(manga.genreNames)"
            )

            if !manga.themes.isEmpty {
                SectionDivider()

                // Themes
                MetadataSection(title: themeSectionTitle) {
                    FlowLayout(spacing: pillSpacing) {
                        ForEach(manga.themes) { theme in
                            FilterablePill(text: theme.localized, color: .purple)
                            {
                                router.navigateToSearch(
                                    filter: CustomSearchDTO(
                                        themes: [theme.rawValue],
                                        contains: true
                                    )
                                )
                            }
                        }
                    }
                }
                .accessibilityLabel(
                    "\(manga.themes.count) section.themes: \(manga.themeNames)"
                )
            }

            if !manga.demographics.isEmpty {
                SectionDivider()

                // Demographics
                MetadataSection(title: demographicSectionTitle) {
                    FlowLayout(spacing: pillSpacing) {
                        ForEach(manga.demographics) { demographic in
                            FilterablePill(
                                text: demographic.localized,
                                color: .green
                            ) {
                                router.navigateToSearch(
                                    filter: CustomSearchDTO(
                                        demographics: [demographic.rawValue],
                                        contains: true
                                    )
                                )
                            }
                        }
                    }
                }
                .accessibilityLabel(
                    "\(manga.demographics.count) section.demographics: \(manga.demographicsNames)"
                )
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Computed titles

    private var authorSectionTitle: LocalizedStringResource {
        manga.authors.count == 1
            ? "section.authors.one" : "section.authors.other"
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

    init(
        title: LocalizedStringKey,
        @ViewBuilder content: @escaping () -> Content
    ) {
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
extension MangaDetailMetadata {
    fileprivate struct MetadataSectionResource<Content: View>: View {
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

    fileprivate func MetadataSection(
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
        .padding(.leading, 8)
        .padding(.trailing, 4)
        .padding(.vertical, 4)
        .background(.tankoPrimary.opacity(0.1), in: Capsule())
        .overlay(
            Capsule()
                .stroke(.tankoPrimary.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ScrollView {
        MangaDetailMetadata(manga: .test)
    }
}
