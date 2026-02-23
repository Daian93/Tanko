//
//  MangaCollectionRepository.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation

// Defines the interface for managing the user's manga collection, abstracting away the underlying storage mechanism (e.g., local database, cloud sync).
@MainActor
protocol MangaCollectionRepository: Sendable {
    func getCollection() async throws -> [MangaSyncData]
    func add(mangaData: MangaSyncData) async throws
    func updateOrCreate(with remote: MangaSyncData) async throws
    func remove(_ manga: UserManga) async throws
}
