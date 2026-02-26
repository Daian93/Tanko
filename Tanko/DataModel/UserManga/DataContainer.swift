//
//  DataContainer.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import SwiftData
import SwiftUI

enum DataContainer {

    @MainActor
    static let shared: ModelContainer = {
        let schema = Schema([
            UserManga.self
        ])

        return try! ModelContainer(for: schema)
    }()
}
