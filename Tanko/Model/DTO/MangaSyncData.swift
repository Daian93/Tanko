//
//  MangaSyncData.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/2/26.
//

import Foundation

/* Internal DTO used to synchronise sleeve data between the local repository (SwiftData) and the remote repository (API). It is also used to persist pending operations when the user is offline. */
struct MangaSyncData {
    let mangaID: Int
    let title: String
    let coverURL: URL?
    let totalVolumes: Int?
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
    let updatedAt: Date
}

// MARK: - Codable

extension MangaSyncData: Codable {
    enum CodingKeys: String, CodingKey {
        case mangaID, title, coverURL, totalVolumes
        case volumesOwned, readingVolume, completeCollection, updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mangaID = try container.decode(Int.self, forKey: .mangaID)
        title = try container.decode(String.self, forKey: .title)
        totalVolumes = try container.decodeIfPresent(Int.self, forKey: .totalVolumes)
        volumesOwned = try container.decode([Int].self, forKey: .volumesOwned)
        readingVolume = try container.decodeIfPresent(Int.self, forKey: .readingVolume)
        completeCollection = try container.decode(Bool.self, forKey: .completeCollection)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)

        if let urlString = try container.decodeIfPresent(String.self, forKey: .coverURL) {
            coverURL = URL(string: urlString)
        } else {
            coverURL = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mangaID, forKey: .mangaID)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(coverURL?.absoluteString, forKey: .coverURL)
        try container.encodeIfPresent(totalVolumes, forKey: .totalVolumes)
        try container.encode(volumesOwned, forKey: .volumesOwned)
        try container.encodeIfPresent(readingVolume, forKey: .readingVolume)
        try container.encode(completeCollection, forKey: .completeCollection)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
