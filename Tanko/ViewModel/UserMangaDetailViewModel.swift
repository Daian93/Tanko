//
//  UserMangaDetailViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class UserMangaDetailViewModel {
    
    // MARK: - Dependencies
    
    private let collectionVM: UserMangaCollectionViewModel
    private(set) var userManga: UserManga
    
    // MARK: - State
    
    var volumesOwned: Set<Int>
    var readingVolume: Int
    var manga: Manga? = nil
    var isLoadingManga = false
    
    var coverURL: URL? {
        userManga.coverURL
    }

    var title: String {
        userManga.title
    }
    
    // MARK: - Initialization
    
    init(
        userManga: UserManga,
        collectionVM: UserMangaCollectionViewModel
    ) {
        self.userManga = userManga
        self.collectionVM = collectionVM
        self.volumesOwned = Set(userManga.volumesOwned)
        self.readingVolume = userManga.readingVolume ?? 0
    }
    
    // MARK: - Computed Properties
    
    /// Total de volúmenes del manga (definido o dinámico)
    var totalVolumes: Int {
        if let definedTotal = userManga.totalVolumes, definedTotal > 0 {
            return definedTotal
        }
        return max(
            readingVolume,
            volumesOwned.max() ?? 0,
            10
        )
    }
    
    /// Máximo volumen permitido para lectura
    var maxVolume: Int {
        if let definedTotal = userManga.totalVolumes, definedTotal > 0 {
            return definedTotal // Límite estricto
        }
        return 999
    }
    
    /// Indica si el manga tiene total de volúmenes definido
    var hasDynamicTotal: Bool {
        userManga.totalVolumes == nil
    }
    
    /// Indica si la colección está completa
    var isCompleteCollection: Bool {
        guard let definedTotal = userManga.totalVolumes, definedTotal > 0 else {
            return false
        }

        return volumesOwned.count == definedTotal
    }
    
    /// Texto del footer del total de volúmenes
    var totalVolumesFooterText: String {
        if let definedTotal = userManga.totalVolumes {
            return "De un total de \(definedTotal) tomos."
        } else {
            return "Total de volúmenes desconocido (dinámico)."
        }
    }
    
    /// Texto del footer de volúmenes seleccionados
    var volumesSelectionFooterText: String {
        "\(volumesOwned.count) de \(totalVolumes) tomos seleccionados"
    }
    
    /// Indica si debe mostrar la sección de estado de colección
    var shouldShowCollectionState: Bool {
        userManga.totalVolumes != nil
    }
    
    // MARK: - Actions
    
    /// Guarda los cambios en el manga
    func saveChanges() {
        if let definedTotal = userManga.totalVolumes {
            readingVolume = min(readingVolume, definedTotal)
        }
        
        userManga.readingVolume = readingVolume == 0 ? nil : readingVolume
        userManga.volumesOwned = Array(volumesOwned).sorted()
        userManga.completeCollection = isCompleteCollection
        userManga.updatedAt = .now
        
        Task {
            await collectionVM.updateRemote(userManga)
        }
    }
    
    /// Incrementa el volumen de lectura
    func incrementReading() {
        guard readingVolume < maxVolume else { return }
        readingVolume += 1
        saveChanges()
    }
    
    /// Decrementa el volumen de lectura
    func decrementReading() {
        guard readingVolume > 0 else { return }
        readingVolume -= 1
        saveChanges()
    }
    
    /// Selecciona todos los volúmenes
    func selectAllVolumes() {
        volumesOwned = Set(1...totalVolumes)
        saveChanges()
    }
    
    /// Deselecciona todos los volúmenes
    func clearAllVolumes() {
        volumesOwned.removeAll()
        saveChanges()
    }
    
    /// Invierte la selección de volúmenes
    func invertSelection() {
        let allVolumes = Set(1...totalVolumes)
        volumesOwned = allVolumes.subtracting(volumesOwned)
        saveChanges()
    }
    
    /// Alterna la selección de un volumen específico
    func toggleVolume(_ number: Int) {
        if volumesOwned.contains(number) {
            volumesOwned.remove(number)
        } else {
            volumesOwned.insert(number)
        }
        saveChanges()
    }
    
    /// Carga el manga completo desde la API
    func loadManga() async {
        guard manga == nil, !isLoadingManga else { return }
        
        isLoadingManga = true
        
        do {
            let network = Network()
            let loadedManga = try await network.getManga(id: userManga.mangaID)
            self.manga = loadedManga
        } catch {
            print("❌ Error cargando manga completo: \(error)")
        }
        
        isLoadingManga = false
    }
}
