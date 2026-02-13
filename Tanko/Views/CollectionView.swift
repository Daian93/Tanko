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
        case completados = "Completados"
    }
    
    var body: some View {
        NavigationStack {
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
                                Button {
                                    withAnimation(.easeInOut) {
                                        selectedFilter = filter
                                    }
                                } label: {
                                    Text(filter.rawValue)
                                        .font(.subheadline.weight(.medium))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedFilter == filter
                                            ? Color("TankoPrimary")
                                            : Color(.systemGray6)
                                        )
                                        .foregroundStyle(
                                            selectedFilter == filter
                                            ? .white
                                            : .primary
                                        )
                                        .clipShape(Capsule())
                                }
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
            .task {
                if session.isAuthenticated {
                    await collectionVM.synchronize()
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
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .onChange(of: session.isAuthenticated) { _, isAuth in
            if isAuth {
                showOnboarding = false
            }
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
        
        private var totalVolumes: Int {
            if let definedTotal = userManga.totalVolumes {
                return definedTotal
            }
            return max(userManga.readingVolume ?? 0,
                      userManga.volumesOwned.max() ?? 0,
                      1)
        }
        
        private var hasDynamicTotal: Bool {
            userManga.totalVolumes == nil
        }
        
        private var reading: Int {
            userManga.readingVolume ?? 0
        }
        
        private var progress: Double {
            guard totalVolumes > 0 else { return 0 }
            return Double(reading) / Double(totalVolumes)
        }
        
        private var progressColor: Color {
            if progress == 0 { return .gray }
            if progress < 0.5 { return .orange }
            if progress < 1 { return Color("TankoSecondary") }
            return .green
        }
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 14) {
                
                // MARK: Top Section
                
                HStack(spacing: 14) {
                    
                    CoverView(
                        cover: userManga.coverURL,
                        namespace: namespace,
                        big: false
                    )
                    .frame(width: 65, height: 95)
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
                                    Text("\(reading)/\(totalVolumes)+")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(progressColor)
                                } else {
                                    Text("\(reading)/\(totalVolumes)")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(progressColor)
                                }
                            }
                            
                            ProgressView(value: progress)
                                .tint(progressColor)
                                .scaleEffect(y: 2.2)
                                .animation(.easeInOut, value: progress)
                        }
                        
                        // Owned badge
                        HStack {
                            Label("\(userManga.volumesOwned.count) tomos",
                                  systemImage: "books.vertical.fill")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.1))
                                .foregroundStyle(.green)
                                .clipShape(Capsule())
                            
                            if userManga.completeCollection {
                                Label("Completo",
                                      systemImage: "checkmark.seal.fill")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                                        showDeleteAlert = true
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(AppColors.primary)
                                            .font(.title2)
                                    }
                                    .buttonStyle(.plain)
                }
                
                // MARK: Bottom Controls
                
                HStack {
                    
                    // +/- Capsule
                    HStack(spacing: 0) {
                        
                        Button {
                            updateReading(by: -1)
                        } label: {
                            Image(systemName: "minus")
                                .frame(width: 34, height: 34)
                        }
                        .disabled(reading <= 0)
                        
                        Divider()
                            .frame(height: 20)
                        
                        if hasDynamicTotal {
                            Text("Vol \(reading)+")
                                .font(.subheadline.weight(.medium))
                                .frame(minWidth: 60)
                        } else {
                            Text("Vol \(reading)")
                                .font(.subheadline.weight(.medium))
                                .frame(minWidth: 60)
                        }
                        
                        Divider()
                            .frame(height: 20)
                        
                        Button {
                            updateReading(by: 1)
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 34, height: 34)
                        }

                        .disabled(!hasDynamicTotal && reading >= totalVolumes)
                    }
                    .foregroundStyle(Color("TankoPrimary"))
                    .background(Color("TankoCardSurface"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2))
                    )
                    
                    Spacer()
                    
                    // Manage Volumes Button
                    
                    Button {
                        showVolumeManagement.toggle()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "square.grid.3x3")
                            Text("Gestionar")
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color("TankoPrimary").opacity(0.1))
                        .foregroundStyle(Color("TankoPrimary"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
            .background(Color("TankoCardSurface"))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
            .sheet(isPresented: $showVolumeManagement) {
                VolumesManagementView(userManga: userManga)
                    .presentationDetents([.medium])
            }
            .alert("Eliminar manga", isPresented: $showDeleteAlert, actions: {
                  Button("Eliminar", role: .destructive) {
                      showDeleteAlert = false
                      Task {
                          try? await Task.sleep(nanoseconds: 100_000_000)
                          await collectionVM.remove(userManga)
                      }
                  }
                  Button("Cancelar", role: .cancel) {}
              }, message: {
                  Text("¿Estás seguro que quieres eliminar este manga de tu colección?")
              })
        }
        
        // MARK: Logic
        
        private func updateReading(by value: Int) {
            let newValue = reading + value
            
            guard newValue >= 0 else { return }
            
            if let definedTotal = userManga.totalVolumes {
                guard newValue <= definedTotal else { return }
                
                withAnimation(.easeInOut) {
                    userManga.readingVolume = newValue
                    userManga.updatedAt = .now
                }
            } else {
                withAnimation(.easeInOut) {
                    userManga.readingVolume = newValue
                    userManga.updatedAt = .now
                }
            }
            
            Task {
                await collectionVM.updateRemote(userManga)
            }
        }
    }

    
    
    struct VolumesManagementView: View {
        @Bindable var userManga: UserManga
        @Environment(UserMangaCollectionViewModel.self) private var collectionVM
        @Environment(\.dismiss) var dismiss
        @State private var maxVolume: Int = 1

        private var hasDynamicTotal: Bool {
            userManga.totalVolumes == nil
        }
        
        private var totalVolumes: Int {
            if let definedTotal = userManga.totalVolumes {
                return definedTotal
            }
            return maxVolume
        }

        private let columns = [GridItem(.adaptive(minimum: 45))]

        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Info text
                        if hasDynamicTotal {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Total de volúmenes desconocido", systemImage: "info.circle")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Color("TankoPrimary"))
                                
                                Text("Este manga no tiene un total definido. Puedes añadir volúmenes según los vayas coleccionando.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color("TankoPrimary").opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        } else {
                            Text("Selecciona los tomos físicos que posees:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }

                        // Volume grid
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(1...totalVolumes, id: \.self) { number in
                                let isOwned = userManga.volumesOwned.contains(number)
                                Button {
                                    toggleVolume(number: number)
                                } label: {
                                    Text("\(number)")
                                        .font(.system(.subheadline, design: .rounded).bold())
                                        .frame(width: 45, height: 45)
                                        .background(isOwned ? Color.green : Color(.secondarySystemBackground))
                                        .foregroundStyle(isOwned ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                            
                            // Add more button for dynamic totals
                            if hasDynamicTotal {
                                Button {
                                    maxVolume += 5
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .frame(width: 45, height: 45)
                                        .background(Color("TankoPrimary").opacity(0.1))
                                        .foregroundStyle(Color("TankoPrimary"))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .navigationTitle("Gestionar Colección")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Hecho") { dismiss() }
                        .fontWeight(.bold)
                }
                .onAppear {
                    if hasDynamicTotal {
                        let currentMax = max(
                            userManga.readingVolume ?? 0,
                            userManga.volumesOwned.max() ?? 0,
                            10
                        )
                        maxVolume = currentMax + 5
                    }
                }
            }
        }
        
        private func toggleVolume(number: Int) {
            var updatedVolumes = userManga.volumesOwned
            
            if updatedVolumes.contains(number) {
                updatedVolumes.removeAll { $0 == number }
            } else {
                updatedVolumes.append(number)
            }
            
            userManga.volumesOwned = updatedVolumes
            userManga.updatedAt = .now
            
            if let total = userManga.totalVolumes, total > 0 {
                userManga.completeCollection = (updatedVolumes.count == total)
            } else {
                userManga.completeCollection = false
            }
            
            Task {
                await collectionVM.updateRemote(userManga)
            }
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
                guard let total = $0.totalVolumes else { return false }
                let reading = $0.readingVolume ?? 0
                return reading > 0 && reading < total
            }
            
        case .completados:
            return userMangas.filter { $0.completeCollection }
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
        
        let totalVolumesOwned = userMangas.reduce(0) { $0 + $1.volumesOwned.count }
        
        return HStack {
            StatItem(label: "Total", value: "\(userMangas.count)", icon: "books.vertical")
            Divider().frame(height: 40)
            StatItem(label: "Leyendo", value: "\(readingCount)", icon: "book")
            Divider().frame(height: 40)
            StatItem(label: "Tomos", value: "\(totalVolumesOwned)", icon: "square.stack.3d.up")
            Divider().frame(height: 40)
            StatItem(label: "Completos", value: "\(completeCount)", icon: "checkmark.seal")
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
