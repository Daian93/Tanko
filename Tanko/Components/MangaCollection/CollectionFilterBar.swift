//
//  CollectionFilterBar.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct CollectionFilterBar: View {
    @Binding var selectedFilter: UserMangaCollectionViewModel.CollectionFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(UserMangaCollectionViewModel.CollectionFilter.allCases, id: \.self) { filter in
                    FilterPill(
                        filter: filter,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - FilterPill

private struct FilterPill: View {
    let filter: UserMangaCollectionViewModel.CollectionFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(filter.localized)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.tankoPrimary : Color(white: 0.95))
                .foregroundStyle(isSelected ? Color.white : .tankoPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var filter = UserMangaCollectionViewModel.CollectionFilter.all
    CollectionFilterBar(selectedFilter: $filter)
}
