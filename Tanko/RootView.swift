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
    @Environment(\.modelContext) private var modelContext
    @State private var collectionVM = UserMangaCollectionViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            if session.canAccessApp {
                MainTabView()
                    .environment(collectionVM)
                    .task {
                        setupViewModel()
                        await collectionVM.loadCollection()
                    }
                    .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .id(session.canAccessApp ? "Authenticated" : "Unauthenticated")
        .animation(.default, value: session.canAccessApp)
    }

    private func setupViewModel() {
        let localRepo = LocalMangaCollectionRepository(context: modelContext)
        let remoteRepo = RemoteMangaCollectionRepository(
            network: Network(),
            session: session,
            localRepo: localRepo
        )
        let factory = CollectionRepositoryFactory(
            session: session,
            remoteRepo: remoteRepo,
            localRepo: localRepo
        )
        collectionVM.setContext(modelContext, factory: factory)
    }
}
