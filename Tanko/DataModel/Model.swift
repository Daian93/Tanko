//
//  Model.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation
import SwiftData

@Model
final class UserManga {
    #Index<UserManga>([\.mangaID])
    @Attribute(.unique) var id: UUID
    var mangaID: Int
    var title: String
    var coverURL: URL?
    var totalVolumes: Int?
    var volumesOwned: [Int]
    var readingVolume: Int?
    var completeCollection: Bool
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        mangaID: Int,
        title: String,
        coverURL: URL?,
        totalVolumes: Int? = nil,
        volumesOwned: [Int] = [],
        readingVolume: Int? = nil,
        completeCollection: Bool = false,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.mangaID = mangaID
        self.title = title
        self.coverURL = coverURL
        self.totalVolumes = totalVolumes
        self.volumesOwned = volumesOwned
        self.readingVolume = readingVolume
        self.completeCollection = completeCollection
        self.updatedAt = updatedAt
    }
}

extension UserManga {
    var asSyncData: MangaSyncData {
        MangaSyncData(
            mangaID: self.mangaID,
            title: self.title,
            coverURL: self.coverURL,
            totalVolumes: self.totalVolumes,
            volumesOwned: self.volumesOwned,
            readingVolume: self.readingVolume,
            completeCollection: self.completeCollection,
            updatedAt: self.updatedAt
        )
    }
}
