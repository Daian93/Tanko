//
//  PreviewHelpers.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 12/2/26.
//

import SwiftUI
import SwiftData

@MainActor
enum PreviewHelper {
    static let container: ModelContainer = {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserManga.self, configurations: config)
    
            UserManga.sampleCollection.forEach { manga in
                container.mainContext.insert(manga)
            }

            try? container.mainContext.save()
            
            return container
        }()

    static func makeCollectionVM() -> UserMangaCollectionViewModel {
        let context = container.mainContext
        let local = LocalMangaCollectionRepository(context: context)
        let remote = RemoteMangaCollectionRepository(
            network: Network(),
            session: SessionManager(),
            localRepo: local
        )
        let sync = MangaCollectionSyncService(local: local, remote: remote)
        
        return UserMangaCollectionViewModel(
            context: context,
            repository: local,
            syncService: sync
        )
    }
}

extension View {
    func withPreviewEnvironment() -> some View {
        self
            .environment(PreviewHelper.makeCollectionVM())
            .environment(SessionManager())
            .environment(AppSettings())
            .environment(MangaViewModel())
            .modelContainer(PreviewHelper.container)
    }
}
