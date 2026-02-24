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
    @Environment(\.modelContext) private var modelContext

    @State private var router = NavigationRouter.shared
    @State private var selectedFilter: UserMangaCollectionViewModel.CollectionFilter = .all
    
    @Namespace private var namespace

    private var filteredMangas: [UserManga] {
        switch selectedFilter {
        case .all:
            return userMangas
        case .toStart:
            return userMangas.filter { ($0.readingVolume ?? 0) == 0 }
        case .reading:
            return userMangas.filter {
                let reading = $0.readingVolume ?? 0
                guard reading > 0 else { return false }
                if let total = $0.totalVolumes, total > 0 { return reading < total }
                return true
            }
        case .read:
            return userMangas.filter {
                guard let total = $0.totalVolumes, total > 0 else { return false }
                return ($0.readingVolume ?? 0) >= total
            }
        case .complete:
            return userMangas.filter { $0.completeCollection }
        }
    }

    private var stats: UserMangaCollectionViewModel.CollectionStats {
        let reading = userMangas.filter {
            let r = $0.readingVolume ?? 0
            guard r > 0 else { return false }
            if let total = $0.totalVolumes, total > 0 { return r < total }
            return true
        }.count
        let complete = userMangas.filter { $0.completeCollection }.count
        let volumes = userMangas.reduce(0) { $0 + $1.volumesOwned.count }
        return UserMangaCollectionViewModel.CollectionStats(
            total: userMangas.count,
            reading: reading,
            volumesOwned: volumes,
            complete: complete
        )
    }

    var body: some View {
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

                        CollectionStatsGrid(stats: stats)
                    }

                    // MARK: - Filters
                    CollectionFilterBar(selectedFilter: $selectedFilter)

                    // MARK: - List
                    VStack(spacing: 12) {
                        if filteredMangas.isEmpty {
                            CollectionEmptyState(filter: selectedFilter)
                                .padding(.top, 40)
                        } else {
                            ForEach(filteredMangas) { manga in
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
            .onChange(of: router.searchPathResetToken) { _, _ in
                router.collectionPath = NavigationPath()
            }
            .navigationDestination(for: UserManga.self) { userManga in
                UserMangaDetailView(
                    userManga: userManga,
                    collectionVM: collectionVM,
                    modelContext: modelContext,
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
