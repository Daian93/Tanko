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
    @State private var showLoadingOverlay = true

    var body: some View {
        Group {
            if session.canAccessApp {
                if let vm = userCollectionVM {
                    if showLoadingOverlay {
                        LoadingView(message: session.isAuthenticated
                                    ? "Sincronizando tu colección..."
                                    : "Cargando biblioteca...")
                        .transition(.opacity)
                    } else {
                        MainTabView()
                            .environment(vm)
                            .transition(.opacity)
                    }
                } else {
                    ProgressView()
                }
            } else {
                OnboardingView()
            }
        }
        .task(id: session.canAccessApp) {
            if session.canAccessApp {
                buildViewModel()
    
                try? await Task.sleep(nanoseconds: 100_000_000)
                if let vm = userCollectionVM {
                    if session.isAuthenticated {
                        await vm.synchronize()
                    } else {
                        await vm.loadCollection()
                    }
                }
        
                try? await Task.sleep(nanoseconds: 500_000_000)
                await MainActor.run {
                    withAnimation {
                        showLoadingOverlay = false
                    }
                }
            }
        }
        .task {
            await session.restoreSession()
        }

        .onChange(of: session.isAuthenticated) { _, newValue in
            guard newValue else { return }
            Task { @MainActor in
                await Task.yield()
                userCollectionVM?.invalidate()
                showLoadingOverlay = true
                buildViewModel()
            }
        }
        .onChange(of: session.didLogout) { _, didLogout in
            guard didLogout else { return }
            Task { @MainActor in
                userCollectionVM?.invalidate()
                userCollectionVM = nil
                await LocalDatabaseCleaner.clear(context: context)
                await Task.yield()
                buildViewModel()
                showLoadingOverlay = true
                session.didLogout = false
            }
        }
    }

    private func buildViewModel() {
        let local = LocalMangaCollectionRepository(context: context)

        let remote: RemoteMangaCollectionRepository? = session.isAuthenticated
            ? RemoteMangaCollectionRepository(
                network: Network(),
                session: session,
                localRepo: local
              )
            : nil

        let repo: any MangaCollectionRepository = remote ?? local
        let syncService = MangaCollectionSyncService(local: local, remote: remote)

        userCollectionVM = UserMangaCollectionViewModel(
            context: context,
            repository: repo,
            syncService: syncService,
            isAuthenticated: session.isAuthenticated
        )
    }
}

#Preview {
    RootView()
        .withPreviewEnvironment()
}
