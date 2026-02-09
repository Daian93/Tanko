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

    init(author: Author) {
        self.author = author
        _viewModel = State(initialValue: AuthorViewModel(author: author))
    }

    // Un grid un poco más apretado suele verse más profesional en móviles
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) { // Más aire entre secciones
                
                header
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 16) {
                    Text("section.mangas_by_author")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)

                    LazyVGrid(columns: columns, spacing: 25) {
                        ForEach(viewModel.mangas) { manga in
                            NavigationLink(value: manga) {
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
                            ProgressView()
                                .tint(AppColors.primary)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadInitial()
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(author.fullName)
                    .font(.title)
                    .fontWeight(.bold)
                    .tracking(-0.5)

                HStack(spacing: 6) {
                    Image(systemName: author.role.icon)
                        .font(.caption2)
                    Text(author.role.localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .foregroundStyle(AppColors.primary)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Capsule())
            }
            Spacer()
        }
        .padding()
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    AuthorMangaView(author: .test)
}
