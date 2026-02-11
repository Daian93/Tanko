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

    var body: some View {
        Group {
            if session.canAccessApp {
                if let vm = userCollectionVM {
                    MainTabView()
                        .environment(vm)
                        .task {
                            if session.canAccessApp {
                                if session.isAuthenticated {
                                    await userCollectionVM?.synchronize()
                                } else {
                                    await userCollectionVM?.loadCollection()
                                }
                            }
                        }
                } else {
                    ProgressView()
                }
            } else {
                OnboardingView()
            }
        }
        .onAppear { buildViewModel() }
    
        .onChange(of: session.isAuthenticated) { old, newValue in
            buildViewModel()
            if newValue {
                Task {
                    await userCollectionVM?.synchronize()
                }
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
