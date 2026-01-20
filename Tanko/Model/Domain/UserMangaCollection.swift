//
//  UserMangaCollection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct UserMangaCollection: Identifiable, Hashable, Codable {
    let id: UUID
    let manga: Manga
    let volumesOwned: Set<Int>
    let readingVolume: Int?
    let completeCollection: Bool
    
    var volumesCount: Int {
        volumesOwned.count
    }
    
    var totalVolumes: Int {
        manga.volumes ?? 0
    }
    
    var isReading: Bool {
        readingVolume != nil
    }
    
    var collectionProgress: Double {
        guard totalVolumes > 0 else { return 0 }
        return Double(volumesCount) / Double(totalVolumes)
    }
    
    var readingProgress: Double {
        guard totalVolumes > 0, let reading = readingVolume else { return 0 }
        return Double(reading) / Double(totalVolumes)
    }
    
    var formattedProgress: String {
        if completeCollection {
            return "Colección completa"
        }
        return "\(volumesCount)/\(totalVolumes) tomos"
    }

    var formattedReadingStatus: String {
        guard let volume = readingVolume else {
            return "No iniciado"
        }
        return "Leyendo tomo \(volume)"
    }
    
    var missingVolumes: [Int] {
        guard let total = manga.volumes, total > 0 else { return [] }
        let allVolumes = Set(1...total)
        return allVolumes.subtracting(volumesOwned).sorted()
    }
}
