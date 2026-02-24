//
//  FiltersViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 3/2/26.
//

import Foundation
import Observation

@Observable @MainActor
final class FiltersViewModel {
    let availableGenres: [Genre] = Genre.allCases
    let availableThemes: [Theme] = Theme.allCases
    let availableDemographics: [Demographic] = Demographic.allCases

    var searchTitle: String = ""
    var searchAuthorFirstName: String = ""
    var searchAuthorLastName: String = ""
    var selectedGenres: Set<Genre> = []
    var selectedThemes: Set<Theme> = []
    var selectedDemographics: Set<Demographic> = []
    var containsSearch: Bool = true

    var hasActiveFilters: Bool {
        !searchTitle.isEmpty || !searchAuthorFirstName.isEmpty
            || !searchAuthorLastName.isEmpty || !selectedGenres.isEmpty
            || !selectedThemes.isEmpty || !selectedDemographics.isEmpty
    }

    func createSearchDTO() -> CustomSearchDTO {
        CustomSearchDTO(
            title: searchTitle.isEmpty ? nil : searchTitle,
            authorFirstName: searchAuthorFirstName.isEmpty
                ? nil : searchAuthorFirstName,
            authorLastName: searchAuthorLastName.isEmpty
                ? nil : searchAuthorLastName,
            genres: selectedGenres.isEmpty
                ? nil : selectedGenres.map { $0.rawValue },
            themes: selectedThemes.isEmpty
                ? nil : selectedThemes.map { $0.rawValue },
            demographics: selectedDemographics.isEmpty
                ? nil : selectedDemographics.map { $0.rawValue },
            contains: containsSearch
        )
    }

    func resetAllFilters() {
        searchTitle = ""
        searchAuthorFirstName = ""
        searchAuthorLastName = ""
        selectedGenres.removeAll()
        selectedThemes.removeAll()
        selectedDemographics.removeAll()
        containsSearch = true
    }

    // Apply the filters from a given SearchDTO (from the pills in SearchView)
    func applyFromDTO(_ dto: CustomSearchDTO) {
        resetAllFilters()
        searchTitle             = dto.title ?? ""
        searchAuthorFirstName   = dto.authorFirstName ?? ""
        searchAuthorLastName    = dto.authorLastName ?? ""
        containsSearch          = dto.contains

        if let genres = dto.genres {
            selectedGenres = Set(genres.compactMap { Genre(rawValue: $0) })
        }
        if let themes = dto.themes {
            selectedThemes = Set(themes.compactMap { Theme(rawValue: $0) })
        }
        if let demographics = dto.demographics {
            selectedDemographics = Set(demographics.compactMap { Demographic(rawValue: $0) })
        }
    }

    var activeFiltersCount: Int {
        var count = 0
        if !searchTitle.isEmpty { count += 1 }
        if !searchAuthorFirstName.isEmpty { count += 1 }
        if !searchAuthorLastName.isEmpty { count += 1 }
        count += selectedGenres.count
        count += selectedThemes.count
        count += selectedDemographics.count
        return count
    }

    // MARK: - Toggle Actions

    func toggleGenre(_ genre: Genre) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
    }

    func toggleTheme(_ theme: Theme) {
        if selectedThemes.contains(theme) {
            selectedThemes.remove(theme)
        } else {
            selectedThemes.insert(theme)
        }
    }

    func toggleDemographic(_ demo: Demographic) {
        if selectedDemographics.contains(demo) {
            selectedDemographics.remove(demo)
        } else {
            selectedDemographics.insert(demo)
        }
    }
}
