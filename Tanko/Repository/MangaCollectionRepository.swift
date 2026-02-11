//
//  MangaCollectionRepository.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation

@MainActor
protocol MangaCollectionRepository: Sendable {
    func getCollection() async throws -> [MangaSyncData]
    func add(mangaData: MangaSyncData) async throws
    func updateOrCreate(with remote: MangaSyncData) async throws
    func remove(_ manga: UserManga) async throws
}
