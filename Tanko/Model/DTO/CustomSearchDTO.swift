//
//  CustomSearchDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct CustomSearchDTO: Codable, Equatable {
    var title: String? = nil
    var authorFirstName: String? = nil
    var authorLastName: String? = nil
    var genres: [String]? = nil
    var themes: [String]? = nil
    var demographics: [String]? = nil
    var contains: Bool = false

    enum CodingKeys: String, CodingKey {
        case title = "searchTitle"
        case authorFirstName = "searchAuthorFirstName"
        case authorLastName = "searchAuthorLastName"
        case genres = "searchGenres"
        case themes = "searchThemes"
        case demographics = "searchDemographics"
        case contains = "searchContains"
    }
}
