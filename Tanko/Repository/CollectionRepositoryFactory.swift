//
//  CollectionRepositoryFactory.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation

@MainActor
final class CollectionRepositoryFactory {

    private let session: SessionManager
    private let local: LocalMangaCollectionRepository
    private let remote: RemoteMangaCollectionRepository

    init(
        session: SessionManager,
        local: LocalMangaCollectionRepository,
        remote: RemoteMangaCollectionRepository
    ) {
        self.session = session
        self.local = local
        self.remote = remote
    }

    func makeRepository() -> MangaCollectionRepository {
        session.isAuthenticated ? remote : local
    }
}
