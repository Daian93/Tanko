//
//  LocalDatabaseCleaner.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftData

@MainActor
enum LocalDatabaseCleaner {

    static func clear(context: ModelContext) async {
        do {
            let fetch = FetchDescriptor<UserManga>()
            let all = try context.fetch(fetch)
            for item in all {
                context.delete(item)
            }
            try context.save()
            print("🧹 Base de datos local limpiada")
        } catch {
            print("❌ Error limpiando base de datos local:", error)
        }
    }
}
