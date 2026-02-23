//
//  CollectionView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftData
import SwiftUI

struct CollectionView: View {
    @Query(sort: \UserManga.title) private var userMangas: [UserManga]
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM
    @Environment(SessionManager.self) private var session
    
    @Namespace private var namespace
    @State private var router = NavigationRouter.shared

    var body: some View {
        @Bindable var vm = collectionVM

        NavigationStack(path: $router.collectionPath) {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Offline Banner
                    if collectionVM.hasPendingOperations {
                        OfflineBanner(
                            isConnected: collectionVM.offlineManager.isConnected,
                            pendingCount: collectionVM.offlineManager.pendingOperationsCount
                        )
                        .padding(.horizontal)
                    }

                    // MARK: - Stats Grid
                    VStack(alignment: .leading, spacing: 8) {
                        Text("stats.title")
                            .font(.title2.bold())
                            .padding(.horizontal)

                        CollectionStatsGrid(stats: collectionVM.collectionStats)
                    }

                    // MARK: - Filters
                    CollectionFilterBar(selectedFilter: $vm.selectedFilter)

                    // MARK: - List
                    VStack(spacing: 12) {
                        if collectionVM.filteredMangas.isEmpty {
                            CollectionEmptyState(filter: collectionVM.selectedFilter)
                                .padding(.top, 40)
                        } else {
                            ForEach(collectionVM.filteredMangas) { manga in
                                MangaProgressRow(userManga: manga, namespace: namespace)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("collection.title")
            .backgroundStyle(.tankoBackground)
            .navigationDestination(for: UserManga.self) { userManga in
                UserMangaDetailView(
                    userManga: userManga,
                    collectionVM: collectionVM,
                    namespace: namespace,
                    navigationPath: $router.collectionPath
                )
            }
            .task {
                if session.isAuthenticated {
                    await collectionVM.synchronize()
                } else {
                    await collectionVM.loadCollection()
                }
            }
            .refreshable {
                if session.isAuthenticated {
                    await collectionVM.synchronize()
                } else {
                    await collectionVM.loadCollection()
                }
            }
        }
    }
}

#Preview {
    CollectionView()
        .withPreviewEnvironment()
}
