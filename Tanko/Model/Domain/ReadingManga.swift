//
//  ReadingManga.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import Foundation

/* Lightweight model used by the Tanko widget. Contains only the necessary information to display the user's current reading progress. */
struct ReadingManga: Identifiable, Codable, Hashable {

    // MARK: - Core Data
    let id: Int
    let title: String
    let coverURL: URL?
    let readingVolume: Int
    let totalVolumes: Int?

    // MARK: - Computed Properties

    // Indicates if total volumes are officially known.
    var hasKnownTotal: Bool {
        guard let total = totalVolumes else { return false }
        return total > 0
    }

    // Normalized progress (0.0–1.0). Returns 0 if totalVolumes unknown.
    var progress: Double {
        guard let total = totalVolumes, total > 0 else { return 0 }
        return min(Double(readingVolume) / Double(total), 1.0)
    }

    // Text shown under progress, e.g., "Vol. 3 / 24" or "Vol. 5+"
    var progressText: String {
        if let total = totalVolumes, total > 0 {
            return "Vol. \(readingVolume) / \(total)"
        } else {
            return "Vol. \(readingVolume)+"
        }
    }

    // Returns true if reading is complete (only when totalVolumes known)
    var isFullyRead: Bool {
        guard let total = totalVolumes else { return false }
        return readingVolume >= total
    }
}

struct ReadingCollection: Codable {
    let mangas: [ReadingManga]
    let lastUpdated: Date
    
    // Provides an empty collection with the current timestamp
    static var empty: ReadingCollection {
        ReadingCollection(
            mangas: [],
            lastUpdated: Date()
        )
    }
}

