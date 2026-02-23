//
//  AuthorMangaView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 8/2/26.
//

import SwiftUI

struct AuthorMangaView: View {
    let author: Author
    @State private var viewModel: AuthorViewModel
    @Namespace private var namespace

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]

    init(author: Author) {
        self.author = author
        _viewModel = State(initialValue: AuthorViewModel(author: author))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AuthorHeader(author: author, large: false)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 16) {
                    Text("section.mangas_by_author")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)

                    LazyVGrid(columns: columns, spacing: 25) {
                        ForEach(viewModel.mangas) { manga in
                            NavigationLink(value: MangaNavigation.withoutTransition(manga)) {
                                MangaGridCard(manga: manga, namespace: namespace)
                                    .task {
                                        await viewModel.loadNextPageIfNeeded(currentItem: manga)
                                    }
                            }
                        }
                    }

                    if viewModel.canLoadMore {
                        HStack {
                            Spacer()
                            ProgressView().tint(.tankoPrimary)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.horizontal)
        }
        .backgroundStyle(.tankoBackground)
        .navigationBarTitleDisplayModeCompatible(.inline)
        .task {
            await viewModel.loadInitial()
        }
    }
}

#Preview {
    NavigationStack {
        AuthorMangaView(author: .test)
    }
}
