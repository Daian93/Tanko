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

extension DemographicDTO {
    static let test = DemographicDTO(
        id: UUID(uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D")!,
        demographic: "Seinen"
    )
}

