//
//  Model.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import Foundation
import SwiftUI

// MARK: - Domain Enums



// MARK: - Domain Models





// MARK: - Manga Extension



// MARK: - MangaStatus Extension



// MARK: - AuthorRole Extension



// MARK: - Helper Extensions

extension String {
    var cleanedURL: String {
        self.replacingOccurrences(of: "\\", with: "")
            .trimmingCharacters(in: .init(charactersIn: "\""))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var asURL: URL? {
        URL(string: cleanedURL)
    }
    
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}

