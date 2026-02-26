//
//  SearchFilterToolbarButton.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/2/26.
//

import SwiftUI

struct SearchFilterToolbarButton: View {
    let hasActiveFilters: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if hasActiveFilters {
                Image("line.3.horizontal.decrease.circle.badge")
                    .font(.title3)
                    .foregroundStyle(.tankoPrimary, .primary)
            } else {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    SearchFilterToolbarButton(hasActiveFilters: true) {}
}
