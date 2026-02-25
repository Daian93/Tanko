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
                    landscapeLayout(geo: geo)
                } else {
                    portraitLayout(geo: geo)
                }
            }
            .background(.background)
            .navigationBarTitleDisplayModeCompatible(.inline)
            .task { await viewModel.loadInitial() }
        }
    }

    // MARK: - Landscape

    @ViewBuilder
    private func landscapeLayout(geo: GeometryProxy) -> some View {
        let cardHeight = geo.size.height * 0.45
        let cardWidth  = cardHeight * 0.7
        let spacing: CGFloat = 40
        let totalContentWidth = CGFloat(viewModel.mangas.count) * cardWidth
            + CGFloat(max(viewModel.mangas.count - 1, 0)) * spacing
        let horizontalInset = max((geo.size.width - totalContentWidth) / 2, 60)

        VStack(alignment: .leading, spacing: 0) {
            AuthorHeader(author: author, large: true)
                .padding(.horizontal, 40)
                .padding(.top, 20)

            Text("section.mangas_by_author")
                .font(.headline)
                .foregroundStyle(.tankoSecondary)
                .padding(.horizontal, 40)
                .padding(.top, 20)

            Spacer()

            AuthorMangaCarousel(
                mangas: viewModel.mangas,
                cardHeight: cardHeight,
                horizontalInset: horizontalInset,
                canLoadMore: viewModel.canLoadMore,
                onLoadMore: { manga in
                    Task { await
                        viewModel.loadNextPageIfNeeded(currentItem: manga)
                    }
                }
            )

            Spacer()
        }
        .frame(minHeight: geo.size.height * 0.7)
    }

    // MARK: - Portrait

    @ViewBuilder
    private func portraitLayout(geo: GeometryProxy) -> some View {
        let horizontalPadding: CGFloat = 40
        let spacing: CGFloat = 30
        let cardWidth = (geo.size.width - (horizontalPadding * 2) - (spacing * 2)) / 3
        let columns = [
            GridItem(.fixed(cardWidth), spacing: spacing),
            GridItem(.fixed(cardWidth), spacing: spacing),
            GridItem(.fixed(cardWidth), spacing: spacing),
        ]

        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                AuthorHeader(author: author, large: true)
                    .padding(.horizontal, 40)
                    .padding(.top, 30)

                Text("section.mangas_by_author")
                    .font(.headline)
                    .foregroundStyle(.tankoSecondary)
                    .padding(.horizontal, 40)

                AuthorMangaGrid(
                    mangas: viewModel.mangas,
                    columns: columns,
                    cardWidth: cardWidth,
                    canLoadMore: viewModel.canLoadMore,
                    onLoadMore: { manga in
                        Task { await
                            viewModel.loadNextPageIfNeeded(currentItem: manga)
                        }
                    }
                )
                .padding(.horizontal, horizontalPadding)
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    AuthorMangaViewiPad(author: .test)
}
