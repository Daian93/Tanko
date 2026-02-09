//
//  FiltersView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 3/2/26.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var filtersViewModel: FiltersViewModel
    let onApply: (CustomSearchDTO) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Búsqueda por texto")) {
                    TextField(
                        "Título del manga",
                        text: $filtersViewModel.searchTitle
                    )
                    TextField(
                        "Nombre del autor",
                        text: $filtersViewModel.searchAuthorFirstName
                    )
                    TextField(
                        "Apellido del autor",
                        text: $filtersViewModel.searchAuthorLastName
                    )
                }

                Section {
                    Toggle(
                        "Búsqueda parcial",
                        isOn: $filtersViewModel.containsSearch
                    )
                }

                Section(header: Text("Géneros")) {
                    ForEach(filtersViewModel.availableGenres) { genre in
                        MultiSelectionRow(
                            title: genre.rawValue,
                            isSelected: filtersViewModel.selectedGenres
                                .contains(genre)
                        ) {
                            toggleGenre(genre)
                        }
                    }
                }

                Section(header: Text("Temáticas")) {
                    ForEach(filtersViewModel.availableThemes) { theme in
                        MultiSelectionRow(
                            title: theme.rawValue,
                            isSelected: filtersViewModel.selectedThemes
                                .contains(theme)
                        ) {
                            toggleTheme(theme)
                        }
                    }
                }

                Section(header: Text("Demografía")) {
                    ForEach(filtersViewModel.availableDemographics) { demo in
                        MultiSelectionRow(
                            title: demo.rawValue,
                            isSelected: filtersViewModel.selectedDemographics
                                .contains(demo)
                        ) {
                            toggleDemographic(demo)
                        }
                    }
                }

                if filtersViewModel.hasActiveFilters {
                    Section {
                        Button(role: .destructive) {
                            filtersViewModel.resetAllFilters()
                        } label: {
                            Text("Limpiar todos los filtros")
                        }
                    }
                }
            }
            .navigationTitle("Filtros")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aplicar") {
                        let dto = filtersViewModel.createSearchDTO()
                        onApply(dto)
                        dismiss()
                    }
                }
            }
        }
    }

    private func toggleGenre(_ genre: Genre) {
        if filtersViewModel.selectedGenres.contains(genre) {
            filtersViewModel.selectedGenres.remove(genre)
        } else {
            filtersViewModel.selectedGenres.insert(genre)
        }
    }

    private func toggleTheme(_ theme: Theme) {
        if filtersViewModel.selectedThemes.contains(theme) {
            filtersViewModel.selectedThemes.remove(theme)
        } else {
            filtersViewModel.selectedThemes.insert(theme)
        }
    }

    private func toggleDemographic(_ demo: Demographic) {
        if filtersViewModel.selectedDemographics.contains(demo) {
            filtersViewModel.selectedDemographics.remove(demo)
        } else {
            filtersViewModel.selectedDemographics.insert(demo)
        }
    }
}

struct MultiSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected { Image(systemName: "checkmark") }
            }
        }
    }
}
