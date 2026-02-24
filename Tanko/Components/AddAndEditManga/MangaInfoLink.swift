//
//  MangaInfoLinkView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaInfoLink: View {
    @State var viewModel: UserMangaDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("info.text")
                .font(.headline)
                .padding(.horizontal)
                .foregroundStyle(.tankoSecondary)

            NavigationLink(value: viewModel.userManga.mangaID) {
                HStack {
                    Label("info.detail", systemImage: "info.circle.fill")
                        .font(.subheadline.bold())
                    Spacer()
                    if viewModel.isLoadingManga {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else if viewModel.manga == nil {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption.bold())
                            .foregroundStyle(.tankoSecondary)
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .foregroundStyle(.tankoSecondary)
                    }
                }
                .foregroundStyle(
                    viewModel.manga != nil ? .tankoPrimary : .tankoSecondary
                )
                .backgroundStyle(.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .task { await viewModel.loadManga() }

            Text("info.footer.text.")
                .font(.caption)
                .foregroundStyle(.tankoSecondary)
                .padding(.horizontal)
        }
    }
}

#Preview {
    let collectionVM = PreviewHelper.makeCollectionVM()
    let viewModel = UserMangaDetailViewModel(
        userManga: .monster,
        collectionVM: collectionVM,
        modelContext: PreviewHelper.makeModelContext()
    )
    
    NavigationStack {
        ZStack {
            Color.tankoBackground.ignoresSafeArea()
            
            MangaInfoLink(viewModel: viewModel)
        }
    }
    .withPreviewEnvironment()
}
