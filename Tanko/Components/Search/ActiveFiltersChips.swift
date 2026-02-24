//
//  ActiveFiltersChips.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/2/26.
//

import SwiftUI

// MARK: - Active Filters Chips Bar

struct ActiveFiltersChips: View {
    @Bindable var filtersVM: FiltersViewModel
    let onFiltersChanged: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Text("active.filters")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(Array(filtersVM.selectedGenres), id: \.self) { genre in
                    FilterChip(title: genre.localized, color: .green) {
                        filtersVM.selectedGenres.remove(genre)
                        onFiltersChanged()
                    }
                }

                ForEach(Array(filtersVM.selectedThemes), id: \.self) { theme in
                    FilterChip(title: theme.localized, color: .orange) {
                        filtersVM.selectedThemes.remove(theme)
                        onFiltersChanged()
                    }
                }

                ForEach(Array(filtersVM.selectedDemographics), id: \.self) { demo in
                    FilterChip(title: demo.localized, color: .pink) {
                        filtersVM.selectedDemographics.remove(demo)
                        onFiltersChanged()
                    }
                }

                if filtersVM.hasActiveFilters {
                    Button {
                        filtersVM.resetAllFilters()
                        onFiltersChanged()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("clean.all")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.tankoPrimary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: LocalizedStringKey
    let color: Color
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color)
        .clipShape(Capsule())
    }
}

#Preview {
    let vm = FiltersViewModel()
    ActiveFiltersChips(filtersVM: vm) {}
        .padding()
}
