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
            if session.canAccessApp, let vm = userCollectionVM {
                if session.isAuthenticated {
                    await vm.synchronize()
                } else {
                    await vm.loadCollection()
                }
            }
        }
        .onAppear {
            buildViewModel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showLoadingOverlay = false
                }
            }
        }
    
        .onChange(of: session.isAuthenticated) { old, newValue in
            buildViewModel()
            showLoadingOverlay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showLoadingOverlay = false
                }
            }
            if newValue {
                Task {
                    await userCollectionVM?.synchronize()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .didLogout)) { _ in
            Task {
                await LocalDatabaseCleaner.clear(context: context)
                buildViewModel()
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
