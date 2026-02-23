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

                Section(header: Text("Categorías")) {
                    DisclosureGroup {
                        ForEach(filtersViewModel.availableGenres) { genre in
                            MultiSelectionRow(
                                title: genre.localized,
                                isSelected: filtersViewModel.selectedGenres
                                    .contains(genre)
                            ) {
                                toggleGenre(genre)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Géneros")
                            Spacer()
                            if !filtersViewModel.selectedGenres.isEmpty {
                                Text("\(filtersViewModel.selectedGenres.count)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.green)
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    DisclosureGroup {
                        ForEach(filtersViewModel.availableThemes) { theme in
                            MultiSelectionRow(
                                title: theme.localized,
                                isSelected: filtersViewModel.selectedThemes
                                    .contains(theme)
                            ) {
                                toggleTheme(theme)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Temáticas")
                            Spacer()
                            if !filtersViewModel.selectedThemes.isEmpty {
                                Text("\(filtersViewModel.selectedThemes.count)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.orange)
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    DisclosureGroup {
                        ForEach(filtersViewModel.availableDemographics) {
                            demo in
                            MultiSelectionRow(
                                title: demo.localized,
                                isSelected: filtersViewModel
                                    .selectedDemographics.contains(demo)
                            ) {
                                toggleDemographic(demo)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Demografía")
                            Spacer()
                            if !filtersViewModel.selectedDemographics.isEmpty {
                                Text(
                                    "\(filtersViewModel.selectedDemographics.count)"
                                )
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.pink)
                                .clipShape(Capsule())
                            }
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
                        .foregroundColor(.accentColor)
                }
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    let mockFiltersVM = FiltersViewModel()

    FiltersView(filtersViewModel: mockFiltersVM) { dto in
        print("Filtros aplicados: \(dto)")
    }
    .withPreviewEnvironment()
}
