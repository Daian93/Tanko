//
//  ThemeDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct ThemeDTO: Codable, Identifiable {
    let id: UUID
    let theme: String
}

extension ThemeDTO {
    var themeType: Theme? {
        Theme(
            rawValue: theme
        )
    }
}
