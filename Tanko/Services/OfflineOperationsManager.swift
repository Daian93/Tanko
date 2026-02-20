//
//  OfflineOperationsManager.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/2/26.
//

import Foundation
import SwiftData
import Network
import Combine

/// Gestor de operaciones pendientes offline
@MainActor
final class OfflineOperationsManager: Observable {
    
    // MARK: - Properties
    
    private let modelContext: ModelContext
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    @Published var pendingOperationsCount: Int = 0
    
    // MARK: - Initialization
    
    init(context: ModelContext) {
        self.modelContext = context
        setupNetworkMonitoring()
        updatePendingCount()
    }
    
    // MARK: - Network Monitoring
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
                print("📡 Conexión: \(path.status == .satisfied ? "✅ Online" : "❌ Offline")")
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    // MARK: - Queue Operations
    
    /// Añade una operación a la cola
    func enqueue(
        action: PendingOperation.Action,
        mangaID: Int,
        mangaTitle: String,
        mangaData: MangaSyncData
    ) {
        let operation = PendingOperation(
            action: action,
            mangaID: mangaID,
            mangaTitle: mangaTitle,
            mangaData: mangaData
        )
        
        modelContext.insert(operation)
        try? modelContext.save()
        
        updatePendingCount()
        
        print("📝 Operación encolada: \(action.rawValue.uppercased()) - \(mangaTitle)")
    }
    
    /// Obtiene todas las operaciones pendientes
    func getPendingOperations() -> [PendingOperation] {
        let descriptor = FetchDescriptor<PendingOperation>(
            sortBy: [SortDescriptor(\.timestamp)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    /// Elimina una operación de la cola
    func dequeue(_ operation: PendingOperation) {
        modelContext.delete(operation)
        try? modelContext.save()
        updatePendingCount()
    }
    
    /// Limpia todas las operaciones completadas
    func clearCompleted() {
        let operations = getPendingOperations()
        for operation in operations {
            modelContext.delete(operation)
        }
        try? modelContext.save()
        updatePendingCount()
    }
    
    /// Actualiza el contador de operaciones pendientes
    private func updatePendingCount() {
        pendingOperationsCount = getPendingOperations().count
    }
    
    // MARK: - Processing
    
    /// Procesa todas las operaciones pendientes
    func processQueue(
        using repository: RemoteMangaCollectionRepository
    ) async -> ProcessingResult {
        guard isConnected else {
            print("⚠️ Sin conexión - operaciones en cola: \(pendingOperationsCount)")
            return ProcessingResult(processed: 0, failed: 0, total: pendingOperationsCount)
        }
        
        let operations = getPendingOperations()
        guard !operations.isEmpty else {
            print("✅ No hay operaciones pendientes")
            return ProcessingResult(processed: 0, failed: 0, total: 0)
        }
        
        print("🔄 Procesando \(operations.count) operaciones pendientes...")
        
        var processedCount = 0
        var failedCount = 0
        
        for operation in operations {
            do {
                try await processOperation(operation, using: repository)
                dequeue(operation)
                processedCount += 1
                print("✅ \(operation.action.rawValue.uppercased()): \(operation.mangaTitle)")
            } catch {
                operation.markAsFailed()
                failedCount += 1
                print("❌ Error procesando \(operation.mangaTitle): \(error)")
                
                // Si falla más de 3 veces, eliminar
                if operation.retryCount > 3 {
                    print("⚠️ Operación descartada tras \(operation.retryCount) intentos")
                    dequeue(operation)
                }
            }
        }
        
        try? modelContext.save()
        updatePendingCount()
        
        print("📊 Procesadas: \(processedCount) | Fallidas: \(failedCount)")
        
        return ProcessingResult(
            processed: processedCount,
            failed: failedCount,
            total: operations.count
        )
    }
    
    /// Procesa una operación individual
    private func processOperation(
        _ operation: PendingOperation,
        using repository: RemoteMangaCollectionRepository
    ) async throws {
        guard let mangaData = operation.getMangaData() else {
            throw OfflineError.invalidData
        }
        
        switch operation.action {
        case .add, .update:
            try await repository.add(mangaData: mangaData)
            
        case .delete:
            // Para delete solo necesitamos el mangaID
            let userManga = UserManga(
                mangaID: mangaData.mangaID,
                title: mangaData.title,
                coverURL: mangaData.coverURL,
                totalVolumes: mangaData.totalVolumes,
                volumesOwned: mangaData.volumesOwned,
                readingVolume: mangaData.readingVolume,
                completeCollection: mangaData.completeCollection,
                updatedAt: mangaData.updatedAt
            )
            try await repository.remove(userManga)
        }
    }
    
    deinit {
        monitor.cancel()
    }
}

// MARK: - Supporting Types

struct ProcessingResult {
    let processed: Int
    let failed: Int
    let total: Int
    
    var hasFailures: Bool { failed > 0 }
    var allProcessed: Bool { processed == total }
}

enum OfflineError: Error {
    case invalidData
    case noConnection
}

