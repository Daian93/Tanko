//
//  ContentViewiPad.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

struct ContentViewiPad: View {
    @Environment(MangasViewModel.self) private var viewModel
    
    @Namespace private var namespace
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 180), spacing: 16)]
    
    var body: some View {
        @Bindable var mangasVM = viewModel
        
        NavigationStack {
            ScrollView {
                switch viewModel.state {
                case .loading:
                    ProgressView("content.loading")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.background)
                    
                case .loaded:
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.mangas) { manga in
                            NavigationLink(value: manga) {
                                MangaRow(manga: manga, namespace: namespace)
                                    .onAppear {
                                        Task {
                                            await viewModel.loadNextPageIfNeeded(currentItem: manga)
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                    .background(AppColors.background)
                    .refreshable {
                        await viewModel.refresh()
                    }
                    
                case .empty:
                    ContentUnavailableView(
                        "content.empty.title",
                        systemImage: "book.closed",
                        description: Text("content.empty.description")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
                }
            }
            .navigationTitle("tab.mangas")
        }
        .task {
            await viewModel.getMangas()
        }
        .alert("error.title", isPresented: $mangasVM.showError) {
            Button("button.ok", role: .cancel) { }
        } message: {
            Text(viewModel.errorMsg)
        }
    }
}

#Preview {
    ContentViewiPad()
        .environment(MangasViewModel())
}

