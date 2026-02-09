//
//  MangaCollectionRepository.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation

@MainActor
protocol MangaCollectionRepository: Sendable {
    func getCollection() async throws -> [UserManga]
    func add(_ manga: UserManga) async throws
    func remove(_ manga: UserManga) async throws
}
