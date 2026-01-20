//
//  PreviewData.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation
import SwiftData

extension UserManga {
    @MainActor static let onePiece = UserManga(
        mangaID: 13,
        title: "One Piece",
        coverURL: URL(string: "https://cdn.myanimelist.net/images/manga/2/253146.jpg"),
        volumesOwned: Array(1...45),
        readingVolume: 46,
        completeCollection: false
    )

    @MainActor static let monster = UserManga(
        mangaID: 1,
        title: "Monster",
        coverURL: URL(string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"),
        volumesOwned: Array(1...18),
        readingVolume: nil,
        completeCollection: true
    )

    @MainActor static let sampleCollection: [UserManga] = [
        onePiece,
        monster
    ]
}

