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
                            // Solo cargamos si la lista está vacía o para refrescar
                            if vm.mangas.isEmpty { await vm.loadCollection() }
                        }
                } else {
                    ProgressView() // Mientras se construye la VM
                }
            } else {
                OnboardingView()
            }
        }
        .onAppear { buildViewModel() }
        // Si cambia el estado de auth, reconstruimos para cambiar repositorios
        .onChange(of: session.isAuthenticated) { _, _ in buildViewModel() }
    }

    private func buildViewModel() {
        let local = LocalMangaCollectionRepository(context: context)
        let remote: RemoteMangaCollectionRepository? = session.isAuthenticated
            ? RemoteMangaCollectionRepository(network: Network(), session: session, localRepo: local)
            : nil
        
        let repo: MangaCollectionRepository = remote ?? local
        
        userCollectionVM = UserMangaCollectionViewModel(
            context: context,
            repository: repo,
            localRepo: local,
            remoteRepo: remote
        )
    }
}
