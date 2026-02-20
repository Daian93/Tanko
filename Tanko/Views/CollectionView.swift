//
//  CollectionView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftData
import SwiftUI

struct CollectionView: View {
    @Query(sort: \UserManga.title) private var userMangas: [UserManga]
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM
    @Environment(SessionManager.self) private var session
    @Environment(\.modelContext) private var context
    @State private var showOnboarding = false
    @Namespace private var namespace
    
    @State private var selectedFilter: CollectionFilter = .todo
    
    enum CollectionFilter: String, CaseIterable {
        case todo = "Todos"
        case porEmpezar = "Por empezar"
        case leyendo = "Leyendo"
        case leidos = "Leídos"
        case completados = "Colección completa"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if collectionVM.offlineManager.pendingOperationsCount > 0 {
                    offlineBanner
                }
                
                ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Estadísticas
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Estadísticas")
                            .font(.title2.bold())
                            .padding(.horizontal)
                        
                        statsGrid
                    }
                    
                    // MARK: - Filtros
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(CollectionFilter.allCases, id: \.self) { filter in
                                filterButton(for: filter)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Lista
                    
                    VStack(spacing: 12) {
                        
                        if filteredMangas.isEmpty {
                            EmptyStateView(filter: selectedFilter)
                                .padding(.top, 40)
                        } else {
                            ForEach(filteredMangas) { manga in
                                MangaProgressRow(
                                    userManga: manga,
                                    namespace: namespace
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Mi Biblioteca")
            .backgroundStyle(AppColors.primary)
            .navigationDestination(for: UserManga.self) { userManga in
                UserMangaDetailView(
                    userManga: userManga,
                    collectionVM: collectionVM,
                    namespace: namespace
                )
            }
            .task {
                if session.isAuthenticated {
                    await collectionVM.synchronize()
                } else {
                    await collectionVM.loadCollection()
                }
            }
            
            .refreshable {
                if session.isAuthenticated {
                    await collectionVM.synchronize()
                } else {
                    await collectionVM.loadCollection()
                }
            }
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .onChange(of: session.isAuthenticated) { _, isAuth in
            if isAuth {
                showOnboarding = false
            }
        }
    }
    
    // MARK: - Offline Banner
    
    private var offlineBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .font(.title3)
                .foregroundStyle(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Operaciones pendientes")
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
                
                Text("\(collectionVM.offlineManager.pendingOperationsCount) cambios sin sincronizar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if collectionVM.offlineManager.isConnected {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.orange.opacity(0.3)),
            alignment: .bottom
        )
    }
    
    // MARK: - Filter Button
    
    private func filterButton(for filter: CollectionFilter) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedFilter = filter
            }
        } label: {
            let isSelected = selectedFilter == filter
            let backgroundColor = isSelected ? Color("TankoPrimary") : Color(white: 0.95)
            let textColor = isSelected ? Color.white : Color.primary
            
            Text(filter.rawValue)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .foregroundStyle(textColor)
                .clipShape(Capsule())
        }
    }
    
    // MARK: - StatItem
    
    struct StatItem: View {
        
        let label: String
        let value: String
        let icon: String
        
        var body: some View {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(Color("TankoPrimary"))
                
                Text(value)
                    .font(.headline)
                
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Manga Row
    
    struct MangaProgressRow: View {
        
        @Bindable var userManga: UserManga
        let namespace: Namespace.ID
        
        @Environment(UserMangaCollectionViewModel.self) private var collectionVM
        @Environment(\.modelContext) private var context
        @State private var showVolumeManagement = false
        @State private var showDeleteAlert = false
        @State private var showErrorAlert = false
        @State private var errorMessage = ""
        
        private var totalVolumes: Int? {
            userManga.totalVolumes
        }
        
        private var hasDynamicTotal: Bool {
            totalVolumes == nil
        }
        
        private var reading: Int {
            userManga.readingVolume ?? 0
        }
        
        private var displayTotal: Int {
            if let total = totalVolumes {
                return total
            }
            return max(reading, userManga.volumesOwned.max() ?? 0, 1)
        }
        
        private var safeReading: Int {
            if let total = totalVolumes {
                return min(reading, total)
            }
            return reading
        }
        
        private var safeTotal: Int {
            if let total = totalVolumes {
                return max(total, 1)
            }
            return max(displayTotal, reading, 1)
        }
        
        private var progress: Double {
            guard safeTotal > 0 else { return 0 }
            let value = Double(safeReading) / Double(safeTotal)
            return min(max(value, 0), 1)
        }
        
        private var isCompleted: Bool {
            guard let total = totalVolumes else { return false }
            return reading >= total
        }
        
        private var progressColor: Color {
            if isCompleted { return .green }
            if progress == 0 { return .gray }
            if progress < 0.5 { return .orange }
            return Color("TankoSecondary")
        }
        
        var body: some View {
            NavigationLink(value: userManga) {
                VStack(alignment: .leading, spacing: 14) {
                    
                    // MARK: Top Section
                    
                    HStack(spacing: 14) {
                    
                    CoverView(
                        cover: userManga.coverURL,
                        namespace: namespace,
                        big: false
                    )
                    .frame(width: 70, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(userManga.title)
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(2)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            HStack {
                                Text("Progreso")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                if hasDynamicTotal {
                                    Text("\(reading)+")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(progressColor)
                                } else {
                                    Text("\(reading)/\(displayTotal)")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(progressColor)
                                }
                            }
                            
                            if hasDynamicTotal {
 
                                ProgressView(value: min(Double(reading) / max(Double(displayTotal), 1), 1.0))
                                    .tint(progressColor)
                                    .scaleEffect(y: 2.2)
                            } else {
                                ProgressView(value: Double(safeReading), total: Double(safeTotal))
                                    .tint(progressColor)
                                    .scaleEffect(y: 2.2)
                                    .animation(.easeInOut, value: progress)
                            }
                        }
                        
                        // Owned badge
                        HStack {
                            Label(
                                "\(userManga.volumesOwned.count) tomos",
                                systemImage: "books.vertical.fill"
                            )
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                            
                            if isCompleted {
                                Label(
                                    "Completo",
                                    systemImage: "checkmark.seal.fill"
                                )
                                .font(.caption2)
                                .foregroundStyle(.green)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color("TankoCardSurface"))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
            .overlay(alignment: .topTrailing) {
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppColors.primary)
                        .font(.title2)
                        .padding(16)
                }
                .buttonStyle(.plain)
            }
            }
            .buttonStyle(.plain)
            .alert(
                "Eliminar manga",
                isPresented: $showDeleteAlert,
                actions: {
                    Button("Eliminar", role: .destructive) {
                        showDeleteAlert = false
                        Task {
                            try? await Task.sleep(nanoseconds: 100_000_000)
                            await collectionVM.remove(userManga)
                        }
                    }
                    Button("Cancelar", role: .cancel) {}
                },
                message: {
                    Text(
                        "¿Estás seguro que quieres eliminar este manga de tu colección?"
                    )
                }
            )
        }
    }
}

extension CollectionView {

    private var filteredMangas: [UserManga] {
        switch selectedFilter {

        case .todo:
            return userMangas

        case .porEmpezar:
            return userMangas.filter {
                ($0.readingVolume ?? 0) == 0
            }

        case .leyendo:
            return userMangas.filter {
                guard let total = $0.totalVolumes else {
                    return ($0.readingVolume ?? 0) > 0
                }
                let reading = $0.readingVolume ?? 0
                return reading > 0 && reading < total
            }

        case .leidos:
            return userMangas.filter {
                guard let total = $0.totalVolumes else { return false }
                return ($0.readingVolume ?? 0) >= total
            }

        case .completados:
            return userMangas.filter {
                // Solo mangas con total definido pueden estar "completados"
                guard let total = $0.totalVolumes, total > 0 else { return false }
                return ($0.readingVolume ?? 0) >= total
            }
        }
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        let readingCount = userMangas.filter {
            guard let total = $0.totalVolumes else { return false }
            let reading = $0.readingVolume ?? 0
            return reading > 0 && reading < total
        }.count

        let completeCount = userMangas.filter { $0.completeCollection }.count

        let totalVolumesOwned = userMangas.reduce(0) {
            $0 + $1.volumesOwned.count
        }

        return HStack {
            StatItem(
                label: "Total",
                value: "\(userMangas.count)",
                icon: "books.vertical"
            )
            Divider().frame(height: 40)
            StatItem(label: "Leyendo", value: "\(readingCount)", icon: "book")
            Divider().frame(height: 40)
            StatItem(
                label: "Tomos",
                value: "\(totalVolumesOwned)",
                icon: "square.stack.3d.up"
            )
            Divider().frame(height: 40)
            StatItem(
                label: "Completos",
                value: "\(completeCount)",
                icon: "checkmark.seal"
            )
        }
        .padding()
        .background(Color("TankoCardSurface"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10)
        .padding(.horizontal)
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {

    let filter: CollectionView.CollectionFilter

    var message: String {
        switch filter {
        case .todo:
            return "No tienes mangas en tu colección todavía."
        case .porEmpezar:
            return "No tienes mangas pendientes de empezar."
        case .leyendo:
            return "No estás leyendo ningún manga actualmente."
        case .leidos:
            return "No has leído ningún manga todavía."
        case .completados:
            return "Aún no has completado ningún manga."
        }
    }

    var body: some View {
        VStack(spacing: 16) {

            Image(systemName: "books.vertical")
                .font(.system(size: 48))
                .foregroundStyle(.gray.opacity(0.4))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    CollectionView()
        .withPreviewEnvironment()
}
