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
    private let remoteRepo: RemoteMangaCollectionRepository
    private let localRepo: LocalMangaCollectionRepository

    init(
        session: SessionManager,
        remoteRepo: RemoteMangaCollectionRepository,
        localRepo: LocalMangaCollectionRepository
    ) {
        self.session = session
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }

    var repository: MangaCollectionRepository {
        if session.isAuthenticated {
            return remoteRepo
        } else {
            return localRepo
        }
    }
}
