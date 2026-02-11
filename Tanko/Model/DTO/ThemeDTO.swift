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

extension ThemeDTO {
    static let test = ThemeDTO(
        id: UUID(uuidString: "4394C99F-615B-494A-929E-356A342A95B8")!,
        theme: "Psychological"
    )
}
