//
//  Page.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct Page<T> {
    let items: [T]
    let metadata: PageMetadata
    
    var isEmpty: Bool { items.isEmpty }
    
    var hasMorePages: Bool { metadata.hasNextPage }
}

struct PageMetadata {
    let total: Int
    let page: Int
    let per: Int
    
    var totalPages: Int {
        guard per > 0 else { return 0 }
        return Int(ceil(Double(total) / Double(per)))
    }
    
    var hasNextPage: Bool {
        page < totalPages
    }
    
    var rangeDisplay: String {
        let start = (page - 1) * per + 1
        let end = min(page * per, total)
        return "\(start)-\(end) de \(total)"
    }
}
