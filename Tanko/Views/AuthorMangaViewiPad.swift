//
//  AuthorMangaViewiPad.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 12/2/26.
//

import SwiftUI

struct AuthorMangaViewiPad: View {
    let author: Author
    @State private var viewModel: AuthorViewModel
    @Namespace private var namespace

    init(author: Author) {
        self.author = author
        _viewModel = State(initialValue: AuthorViewModel(author: author))
    }

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            Group {
                if isLandscape {
                    VStack(alignment: .leading, spacing: 0) {
                        header
                            .padding(.horizontal, 40)
                            .padding(.top, 20)

                        Text("section.mangas_by_author")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 40)
                            .padding(.top, 20)

                        landscapeSection(geo: geo)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 40) {
                            header
                                .padding(.horizontal, 40)
                                .padding(.top, 30)

                            Text("section.mangas_by_author")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 40)

                            portraitSection(geo: geo)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayModeCompatible(.inline)
            .task {
                await viewModel.loadInitial()
            }
        }
    }

    // MARK: - Landscape Layout
    private func landscapeSection(geo: GeometryProxy) -> some View {
        let cardHeight = geo.size.height * 0.45
        let cardWidth = cardHeight * 0.7
        let spacing: CGFloat = 40

        let totalContentWidth =
            CGFloat(viewModel.mangas.count) * cardWidth + CGFloat(
                max(viewModel.mangas.count - 1, 0)
            ) * spacing

        let horizontalInset = max((geo.size.width - totalContentWidth) / 2, 60)

        return VStack(spacing: 0) {
            Spacer()

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(viewModel.mangas) { manga in
                        NavigationLink(value: manga) {
                            MangaCardLandscape(
                                manga: manga,
                                namespace: namespace,
                                height: cardHeight
                            )
                            .task {
                                await viewModel.loadNextPageIfNeeded(
                                    currentItem: manga
                                )
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    if viewModel.canLoadMore {
                        ProgressView()
                            .frame(width: 150)
                    }
                }
                .padding(.horizontal, horizontalInset)
            }
            .frame(height: cardHeight + 100)

            Spacer()
        }
        .frame(minHeight: geo.size.height * 0.7)
    }

    // MARK: - Portrait Layout
    private func portraitSection(geo: GeometryProxy) -> some View {

        let horizontalPadding: CGFloat = 40
        let spacing: CGFloat = 30
        let cardWidth =
            (geo.size.width - (horizontalPadding * 2) - (spacing * 2)) / 3

        let columns = [
            GridItem(.fixed(cardWidth), spacing: spacing),
            GridItem(.fixed(cardWidth), spacing: spacing),
            GridItem(.fixed(cardWidth), spacing: spacing),
        ]

        return LazyVGrid(columns: columns, spacing: 30) {
            ForEach(viewModel.mangas) { manga in
                NavigationLink(value: manga) {
                    MangaCardPortrait(
                        manga: manga,
                        namespace: namespace,
                        width: cardWidth
                    )
                    .task {
                        await viewModel.loadNextPageIfNeeded(currentItem: manga)
                    }
                }
                .buttonStyle(.plain)
            }

            if viewModel.canLoadMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .padding(.horizontal, horizontalPadding)
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {

                Text(author.fullName)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                HStack(spacing: 8) {
                    Image(systemName: author.role.icon)
                        .font(.caption)

                    Text(author.role.localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundStyle(AppColors.primary)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Capsule())
            }

            Spacer()
        }
        .padding(30)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.25), radius: 8, y: 3)
    }
}

// MARK: - Portrait Card (cuadrada tipo móvil pero más grande)

struct MangaCardPortrait: View {
    let manga: Manga
    let namespace: Namespace.ID
    var width: CGFloat
    private var height: CGFloat { width * 1.3 }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                Color.gray.opacity(0.2)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        Image(systemName: "book")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.6))
                    )
            }
            .matchedGeometryEffect(id: "cover-\(manga.id)", in: namespace)

            VStack(alignment: .leading, spacing: 2) {
                Text(manga.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(AppColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.yellow)
                    Text(manga.formattedScore)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(height: width * 1.5)
    }
}

// MARK: - Landscape Card (vertical centrada)
struct MangaCardLandscape: View {
    let manga: Manga
    let namespace: Namespace.ID
    var height: CGFloat
    private var width: CGFloat { height * 0.7 }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                placeholderView(w: width, h: height)
            }
            .matchedGeometryEffect(id: "cover-\(manga.id)", in: namespace)

            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(AppColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text(manga.formattedScore)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(width: width, height: height + 80)
    }

    private func placeholderView(w: CGFloat, h: CGFloat) -> some View {
        AppColors.surface
            .frame(width: w, height: h)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                Image(systemName: "book")
                    .font(.largeTitle)
                    .foregroundStyle(AppColors.primary)
            )
    }
}
#Preview {
    @Previewable @Namespace var namespace
    AuthorMangaViewiPad(author: .test)
}
