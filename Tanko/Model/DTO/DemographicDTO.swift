//
//  DemographicDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct DemographicDTO: Codable, Identifiable {
    let id: UUID
    let demographic: String
}

extension DemographicDTO {
    var demographicType: Demographic? {
        Demographic(
            rawValue: demographic
        )
    }
}
