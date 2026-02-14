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
    @State private var isInitialLoading = false
    @State private var hasLoadedOnce = false

    var body: some View {
        Group {
            if session.canAccessApp {
                if let vm = userCollectionVM {
                    if isInitialLoading || !hasLoadedOnce {
                        // Show loading screen during initial sync
                        LoadingView(message: session.isAuthenticated
                            ? "Sincronizando tu colección..."
                            : "Cargando tu biblioteca...")
                    } else {
                        // Show main app
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
        .animation(.easeInOut(duration: 0.3), value: isInitialLoading)
        .onAppear {
            buildViewModel()
        }
        .task(id: session.canAccessApp) {
            // Initial load/sync when user accesses the app (authenticated OR guest)
            guard session.canAccessApp, let vm = userCollectionVM else { return }
            
            isInitialLoading = true
            hasLoadedOnce = false
            
            // Track when loading started
            let startTime = Date()
            
            if session.isAuthenticated {
                await vm.synchronize()
            } else if session.isGuest {
                await vm.loadCollection()
            }
            
            // Calculate elapsed time
            let elapsed = Date().timeIntervalSince(startTime)
            let minimumDisplayTime: TimeInterval = 1.5 // 1.5 seconds minimum
            
            // If loading was too fast, add delay to avoid jarring flash
            if elapsed < minimumDisplayTime {
                let remainingTime = minimumDisplayTime - elapsed
                try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
            }
            
            // Hide loading screen after minimum display time
            withAnimation {
                isInitialLoading = false
                hasLoadedOnce = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .didLogout)) { _ in
            Task {
                await LocalDatabaseCleaner.clear(context: context)
                buildViewModel() // Reinicia con repos locales
            }
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
