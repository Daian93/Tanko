//
//  PendingOperation.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/2/26.
//

import Foundation
import SwiftData

// Represents an operation (add, update, delete) that is pending synchronization with the server.
@Model
final class PendingOperation {
    enum Action: String, Codable {
        case add = "add"
        case update = "update"
        case delete = "delete"
    }
    
    // MARK: - Properties
    
    @Attribute(.unique) var id: UUID
    var actionRaw: String
    var mangaID: Int
    var mangaTitle: String
    var mangaDataJSON: Data?
    var timestamp: Date
    var retryCount: Int
    var hasFailed: Bool
    
    // MARK: - Computed Properties
    
    var action: Action {
        get { Action(rawValue: actionRaw) ?? .update }
        set { actionRaw = newValue.rawValue }
    }
    
    // MARK: - Initialization
    
    init(
        action: Action,
        mangaID: Int,
        mangaTitle: String,
        mangaData: MangaSyncData? = nil,
        timestamp: Date = .now
    ) {
        self.id = UUID()
        self.actionRaw = action.rawValue
        self.mangaID = mangaID
        self.mangaTitle = mangaTitle
        self.timestamp = timestamp
        self.retryCount = 0
        self.hasFailed = false
        
        // Serialize mangaData to JSON for storage
        if let mangaData = mangaData {
            self.mangaDataJSON = try? JSONEncoder().encode(mangaData)
        }
    }
    
    // MARK: - Methods
    
    func getMangaData() -> MangaSyncData? {
        guard let json = mangaDataJSON else { return nil }
        return try? JSONDecoder().decode(MangaSyncData.self, from: json)
    }
    
    func markAsFailed() {
        hasFailed = true
        retryCount += 1
    }
    
    func resetFailureState() {
        hasFailed = false
        retryCount = 0
    }
}
