//
//  PreviewDataModel.swift
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
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/2/253146.jpg"
        ),
        totalVolumes: nil,
        volumesOwned: Array(1...5),
        readingVolume: 5,
        completeCollection: false
    )

    @MainActor static let monster = UserManga(
        mangaID: 1,
        title: "Monster",
        coverURL: URL(
            string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"
        ),
        totalVolumes: 18,
        volumesOwned: Array(1...18),
        readingVolume: nil,
        completeCollection: false
    )

    @MainActor static let sampleCollection: [UserManga] = [
        onePiece,
        monster,
    ]
}
