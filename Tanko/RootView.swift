//
//  RootView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(SessionManager.self) private var session
    @Environment(\.modelContext) private var context
    @State private var userCollectionVM: UserMangaCollectionViewModel?
    
    @State private var isInitialSyncDone = false

    var body: some View {
        Group {
            if session.canAccessApp {
                if let vm = userCollectionVM {
                    if !isInitialSyncDone {
                        LoadingView(message: session.isAuthenticated
                                    ? "Sincronizando tu colección..."
                                    : "Cargando biblioteca...")
                        .task {
                            await performInitialLoad(vm: vm)
                        }
                    } else {
                        MainTabView()
                            .environment(vm)
                    }
                } else {
                    ProgressView()
                }
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            if userCollectionVM == nil {
                buildViewModel()
            }
        }
        .onChange(of: session.isAuthenticated) { _, _ in
            isInitialSyncDone = false
            buildViewModel()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didLogout)) { _ in
            Task {
                await LocalDatabaseCleaner.clear(context: context)
                isInitialSyncDone = false
                buildViewModel()
            }
        }
    }

    // MARK: - Lógica de carga
    private func performInitialLoad(vm: UserMangaCollectionViewModel) async {
        let startTime = Date()
        
        if session.isAuthenticated {
            await vm.synchronize()
        } else {
            await vm.loadCollection()
        }
        
        let elapsed = Date().timeIntervalSince(startTime)
        if elapsed < 1.2 {
            try? await Task.sleep(nanoseconds: UInt64((1.2 - elapsed) * 1_000_000_000))
        }
        
        withAnimation {
            isInitialSyncDone = true
        }
    }

    private func buildViewModel() {
        let local = LocalMangaCollectionRepository(context: context)
        let remote: RemoteMangaCollectionRepository? = session.isAuthenticated
            ? RemoteMangaCollectionRepository(network: Network(), session: session, localRepo: local)
            : nil
        
        let repo: MangaCollectionRepository = remote ?? local

        let syncService = MangaCollectionSyncService(
            local: local,
            remote: remote ?? RemoteMangaCollectionRepository(network: Network(), session: session, localRepo: local)
        )
        
        userCollectionVM = UserMangaCollectionViewModel(
            context: context,
            repository: repo,
            syncService: syncService
        )
    }
}

#Preview {
    RootView()
        .withPreviewEnvironment()
}
