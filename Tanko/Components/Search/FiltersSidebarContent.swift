//
//  FiltersSidebarContent.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/2/26.
//

import SwiftUI

// Contenido de filtros reutilizable entre FiltersView (iPhone sheet)
// y SearchViewiPad (sidebar del NavigationSplitView)
struct FiltersSidebarContent: View {
    @Bindable var filtersVM: FiltersViewModel

    var body: some View {
        Section(header: Text("filter.header").font(.headline)) {
            TextField("manga.title", text: $filtersVM.searchTitle)
            TextField("author.name", text: $filtersVM.searchAuthorFirstName)
            TextField("author.surname", text: $filtersVM.searchAuthorLastName)
            Toggle("partial.search", isOn: $filtersVM.containsSearch)
        }
        .listRowBackground(Color.surface)

        Section(header: Text("filter.categories")) {
            // Genres
            DisclosureGroup {
                ForEach(filtersVM.availableGenres) { genre in
                    MultiSelectionRow(
                        title: genre.localized,
                        isSelected: filtersVM.selectedGenres.contains(genre)
                    ) {
                        filtersVM.toggleGenre(genre)
                    }
                }
            } label: {
                FilterSectionLabel(
                    title: "filter.genres",
                    count: filtersVM.selectedGenres.count,
                    color: .green
                )
            }

            // Themes
            DisclosureGroup {
                ForEach(filtersVM.availableThemes) { theme in
                    MultiSelectionRow(
                        title: theme.localized,
                        isSelected: filtersVM.selectedThemes.contains(theme)
                    ) {
                        filtersVM.toggleTheme(theme)
                    }
                }
            } label: {
                FilterSectionLabel(
                    title: "filter.themes",
                    count: filtersVM.selectedThemes.count,
                    color: .orange
                )
            }

            // Demographics
            DisclosureGroup {
                ForEach(filtersVM.availableDemographics) { demo in
                    MultiSelectionRow(
                        title: demo.localized,
                        isSelected: filtersVM.selectedDemographics.contains(demo)
                    ) {
                        filtersVM.toggleDemographic(demo)
                    }
                }
            } label: {
                FilterSectionLabel(
                    title: "filter.demographics",
                    count: filtersVM.selectedDemographics.count,
                    color: .pink
                )
            }
        }
        .listRowBackground(Color.surface)
    }
}

// MARK: - Filter Section Label

struct FilterSectionLabel: View {
    let title: LocalizedStringKey
    let count: Int
    let color: Color

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if count > 0 {
                Text("\(count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(color)
                    .clipShape(Capsule())
            }
        }
    }
}

// MARK: - Multi Selection Row

struct MultiSelectionRow: View {
    let title: LocalizedStringKey
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.tankoPrimary)
                }
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    let vm = FiltersViewModel()
    Form {
        FiltersSidebarContent(filtersVM: vm)
    }
}
