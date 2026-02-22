//
//  OfflineOperationsManager.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/2/26.
//

import Foundation
import SwiftData
import Network

@Observable
@MainActor
final class OfflineOperationsManager {

    // MARK: - Properties

    private let modelContext: ModelContext
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(
        label: "com.tanko.NetworkMonitor",
        qos: .utility
    )

    private(set) var isConnected: Bool = true
    private(set) var pendingOperationsCount: Int = 0

    // Evita procesar la queue múltiples veces simultáneamente
    private var isProcessingQueue = false

    // Callback para procesar la queue cuando vuelve la conexión
    var onConnectionRestored: (() async -> Void)?

    // MARK: - Initialization

    init(context: ModelContext) {
        self.modelContext = context
        updatePendingCount()
        setupNetworkMonitoring()
    }

    // MARK: - Network Monitoring

    private func setupNetworkMonitoring() {
        // Obtenemos el estado inicial ANTES de arrancar el monitor
        let initialPath = monitor.currentPath
        isConnected = initialPath.status == .satisfied

        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            Task { @MainActor [weak self] in
                guard let self else { return }
                let wasConnected = self.isConnected

                // Solo actualizamos si realmente cambió el estado
                guard wasConnected != connected else { return }

                self.isConnected = connected
                print("📡 Red: \(connected ? "✅ Online" : "❌ Offline")")

                // Si acabamos de recuperar conexión, procesamos la queue
                if connected && !wasConnected {
                    print("🔁 Conexión restaurada - procesando operaciones pendientes...")
                    await self.onConnectionRestored?()
                }
            }
        }
        monitor.start(queue: monitorQueue)
    }

    // MARK: - Queue Operations

    func enqueue(
        action: PendingOperation.Action,
        mangaID: Int,
        mangaTitle: String,
        mangaData: MangaSyncData
    ) {
        // Evitar duplicados: si ya existe una operación del mismo tipo para el mismo manga, la reemplazamos
        let existing = getPendingOperations().filter {
            $0.mangaID == mangaID && $0.action == action
        }
        existing.forEach { modelContext.delete($0) }

        let operation = PendingOperation(
            action: action,
            mangaID: mangaID,
            mangaTitle: mangaTitle,
            mangaData: mangaData
        )

        modelContext.insert(operation)
        try? modelContext.save()
        updatePendingCount()

        print("📝 Encolado: \(action.rawValue.uppercased()) - \(mangaTitle) (\(pendingOperationsCount) pendientes)")
    }

    func getPendingOperations() -> [PendingOperation] {
        let descriptor = FetchDescriptor<PendingOperation>(
            sortBy: [SortDescriptor(\.timestamp)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func dequeue(_ operation: PendingOperation) {
        modelContext.delete(operation)
        try? modelContext.save()
        updatePendingCount()
    }

    func clearAll() {
        getPendingOperations().forEach { modelContext.delete($0) }
        try? modelContext.save()
        updatePendingCount()
    }

    private func updatePendingCount() {
        pendingOperationsCount = getPendingOperations().count
    }

    // MARK: - Processing

    func processQueue(
        using repository: RemoteMangaCollectionRepository
    ) async -> ProcessingResult {
        guard isConnected else {
            return ProcessingResult(processed: 0, failed: 0, total: pendingOperationsCount)
        }

        guard !isProcessingQueue else {
            print("⚠️ Queue ya siendo procesada")
            return ProcessingResult(processed: 0, failed: 0, total: pendingOperationsCount)
        }

        let operations = getPendingOperations()
        guard !operations.isEmpty else {
            return ProcessingResult(processed: 0, failed: 0, total: 0)
        }

        isProcessingQueue = true
        defer { isProcessingQueue = false }

        print("🔄 Procesando \(operations.count) operaciones pendientes...")

        var processed = 0
        var failed = 0

        for operation in operations {
            do {
                try await processOperation(operation, using: repository)
                dequeue(operation)
                processed += 1
                print("✅ \(operation.action.rawValue.uppercased()): \(operation.mangaTitle)")
            } catch {
                operation.markAsFailed()
                failed += 1
                print("❌ Error: \(operation.mangaTitle) - \(error.localizedDescription)")

                if operation.retryCount > 3 {
                    print("⚠️ Descartada tras \(operation.retryCount) intentos: \(operation.mangaTitle)")
                    dequeue(operation)
                }
            }
        }

        try? modelContext.save()
        updatePendingCount()

        if processed > 0 || failed > 0 {
            print("📊 Procesadas: \(processed) | Fallidas: \(failed) | Pendientes: \(pendingOperationsCount)")
        }

        return ProcessingResult(processed: processed, failed: failed, total: operations.count)
    }

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
