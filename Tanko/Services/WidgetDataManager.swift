//
//  WidgetDataManager.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 15/2/26.
//

import Foundation
import WidgetKit

final class WidgetDataManager {

    @MainActor static let shared = WidgetDataManager()
    private init() {}

    private let appGroupID = "group.com.dianars.Tanko"
    private let fileName = "readingCollection.json"

    private var fileURL: URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
            .appendingPathComponent(fileName)
    }

    // MARK: - SAVE (called from app)

    @MainActor
    func save(_ mangas: [ReadingManga]) {
        guard let fileURL else {
            print("❌ Widget: No se pudo obtener fileURL para App Group")
            return
        }

        let collection = ReadingCollection(
            mangas: mangas,
            lastUpdated: Date()
        )

        do {
            let data = try JSONEncoder().encode(collection)
            try data.write(to: fileURL, options: [.atomic])
            
            print("✅ Widget: Datos guardados en \(fileURL.path)")
            print("📝 Contenido: \(String(data: data, encoding: .utf8) ?? "no decodificable")")

            WidgetCenter.shared.reloadAllTimelines()
            print("🔄 Widget: Timeline recargado")

        } catch {
            print("❌ Error saving widget data: \(error)")
        }
    }
    
    // MARK: - LOAD (called from widget)
    
    func load() -> ReadingCollection {
        guard let fileURL else {
            print("❌ Widget: No se pudo obtener fileURL para App Group (load)")
            return .empty
        }
        
        print("📂 Widget: Intentando leer desde \(fileURL.path)")
        
        guard let data = try? Data(contentsOf: fileURL) else {
            print("⚠️ Widget: No se pudo leer el archivo, devolviendo colección vacía")
            return .empty
        }
        
        print("📊 Widget: Datos leídos (\(data.count) bytes)")
        
        guard let decoded = try? JSONDecoder().decode(ReadingCollection.self, from: data) else {
            print("❌ Widget: Error decodificando JSON")
            return .empty
        }

        print("✅ Widget: \(decoded.mangas.count) mangas cargados")
        for manga in decoded.mangas {
            print("  📚 \(manga.title) - \(manga.coverURL?.absoluteString ?? "sin URL")")
        }
        
        return decoded
    }
}
