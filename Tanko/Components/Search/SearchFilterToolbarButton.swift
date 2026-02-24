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
            ZStack(alignment: .topTrailing) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title3)

                if hasActiveFilters {
                    Circle()
                        .fill(.red)
                        .frame(width: 7, height: 7)
                        .offset(x: 4, y: -4)
                }
            }
        }
    }
}

#Preview {
    SearchFilterToolbarButton(hasActiveFilters: true) {}
}
