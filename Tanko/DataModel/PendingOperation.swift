//
//  PendingOperation.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/2/26.
//

import Foundation
import SwiftData

/// Representa una operación pendiente de sincronizar con el servidor
@Model
final class PendingOperation {
    
    /// Tipo de acción a realizar
    enum Action: String, Codable {
        case add = "add"
        case update = "update"
        case delete = "delete"
    }
    
    // MARK: - Properties
    
    /// ID único de la operación
    @Attribute(.unique) var id: UUID
    
    /// Tipo de acción (add, update, delete)
    var actionRaw: String
    
    /// ID del manga afectado
    var mangaID: Int
    
    /// Título del manga (para mostrar en UI)
    var mangaTitle: String
    
    /// Datos serializados del manga (JSON)
    var mangaDataJSON: Data?
    
    /// Timestamp de cuando se creó la operación
    var timestamp: Date
    
    /// Número de intentos de sincronización
    var retryCount: Int
    
    /// Si la operación falló
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
        
        // Serializar mangaData a JSON si existe
        if let mangaData = mangaData {
            self.mangaDataJSON = try? JSONEncoder().encode(mangaData)
        }
    }
    
    // MARK: - Methods
    
    /// Recupera los datos del manga desde JSON
    func getMangaData() -> MangaSyncData? {
        guard let json = mangaDataJSON else { return nil }
        return try? JSONDecoder().decode(MangaSyncData.self, from: json)
    }
    
    /// Marca la operación como fallida
    func markAsFailed() {
        hasFailed = true
        retryCount += 1
    }
    
    /// Resetea el estado de fallo
    func resetFailureState() {
        hasFailed = false
        retryCount = 0
    }
}

// MARK: - MangaSyncData Codable

extension MangaSyncData: Codable {
    enum CodingKeys: String, CodingKey {
        case mangaID, title, coverURL, totalVolumes
        case volumesOwned, readingVolume, completeCollection, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mangaID = try container.decode(Int.self, forKey: .mangaID)
        title = try container.decode(String.self, forKey: .title)
        coverURL = try container.decodeIfPresent(URL.self, forKey: .coverURL)
        totalVolumes = try container.decodeIfPresent(Int.self, forKey: .totalVolumes)
        volumesOwned = try container.decode([Int].self, forKey: .volumesOwned)
        readingVolume = try container.decodeIfPresent(Int.self, forKey: .readingVolume)
        completeCollection = try container.decode(Bool.self, forKey: .completeCollection)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mangaID, forKey: .mangaID)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(coverURL, forKey: .coverURL)
        try container.encodeIfPresent(totalVolumes, forKey: .totalVolumes)
        try container.encode(volumesOwned, forKey: .volumesOwned)
        try container.encodeIfPresent(readingVolume, forKey: .readingVolume)
        try container.encode(completeCollection, forKey: .completeCollection)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
