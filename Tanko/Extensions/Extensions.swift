//
//  Extensions.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

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
