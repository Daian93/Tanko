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
    var addedAt: Date

    init(
        id: UUID = UUID(),
        mangaID: Int,
        title: String,
        coverURL: URL?,
        totalVolumes: Int? = nil,
        volumesOwned: [Int] = [],
        readingVolume: Int? = nil,
        completeCollection: Bool = false
    ) {
        self.id = id
        self.mangaID = mangaID
        self.title = title
        self.coverURL = coverURL
        self.totalVolumes = totalVolumes
        self.volumesOwned = volumesOwned
        self.readingVolume = readingVolume
        self.completeCollection = completeCollection
        self.addedAt = Date()
    }
}
