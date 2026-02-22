//
//  MangaStatusBadge.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaStatusBadge: View {
    let status: MangaStatus

    var body: some View {
        Text(status.localized)
            .font(.caption)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

#Preview("Finished status") {
    MangaStatusBadge(status: .finished)
}


