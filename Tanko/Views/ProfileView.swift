//
//  ProfileView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftData
import SwiftUI

struct ProfileView: View {
    @Query(sort: \UserManga.title) private var userMangas: [UserManga]

    @Environment(SessionManager.self) private var session
    @Environment(\.modelContext) private var context
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerView

                    statsGrid

                    VStack(alignment: .leading, spacing: 20) {
                        LibraryListSection(
                            title: "Leyendo actualmente",
                            mangas: userMangas.filter {
                                $0.readingVolume != nil
                                    && !$0.completeCollection
                            },
                            namespace: namespace
                        )

                        LibraryListSection(
                            title: "Completados",
                            mangas: userMangas.filter { $0.completeCollection },
                            namespace: namespace
                        )

                        LibraryListSection(
                            title: "Lista de deseos / Por empezar",
                            mangas: userMangas.filter {
                                $0.readingVolume == nil
                                    && !$0.completeCollection
                            },
                            namespace: namespace
                        )
                    }
                    
                    // Botón de logout al final de la lista
                    logoutButton
                        .padding(.vertical, 30)
                }
            }
            .navigationTitle("Mi Biblioteca")
            .backgroundStyle(AppColors.primary)
            .toolbar {
                // Icono de logout en la barra superior
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        withAnimation {
                            session.logout()
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }

    private var headerView: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.red.opacity(0.1))
                .frame(width: 70, height: 70)
                .overlay(
                    Text(session.user?.email.prefix(2).uppercased() ?? "DR")
                        .font(.headline)
                        .foregroundStyle(.red)
                )

            VStack(alignment: .leading) {
                Text(session.isGuest ? "Modo Invitado" : "Mi Perfil")
                    .font(.title3.bold())
                Text("\(userMangas.count) mangas en total")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    private var statsGrid: some View {
        let readingCount = userMangas.filter {
            $0.readingVolume != nil && !$0.completeCollection
        }.count
        let completeCount = userMangas.filter { $0.completeCollection }.count

        let totalVolumesOwned = userMangas.reduce(0) {
            $0 + $1.volumesOwned.count
        }

        return HStack {
            StatItem(label: "Leyendo", value: "\(readingCount)", icon: "book")
            Divider().frame(height: 40)
            StatItem(
                label: "Tomos",
                value: "\(totalVolumesOwned)",
                icon: "books.vertical"
            )
            Divider().frame(height: 40)
            StatItem(
                label: "Completos",
                value: "\(completeCount)",
                icon: "checkmark.seal"
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10)
        .padding(.horizontal)
    }
    
    private var logoutButton: some View {
        Button {
            withAnimation {
                handleLogout()
            }
        } label: {
            HStack {
                Image(systemName: "power")
                Text("Cerrar Sesión")
            }
            .font(.subheadline.bold())
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }
    
    private func handleLogout() {
        withAnimation {
            if session.isAuthenticated {
                // Si es usuario real, borramos base de datos
                let localRepo = LocalMangaCollectionRepository(context: context)
                session.logout(clearData: true, localRepo: localRepo)
            } else {
                // Si es invitado, solo salimos al onboarding (conservando local)
                session.logout(clearData: false)
            }
        }
    }
}

// MARK: - Subvistas auxiliares

struct LibraryListSection: View {
    let title: String
    let mangas: [UserManga]
    let namespace: Namespace.ID

    var body: some View {
        if !mangas.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)
                    .padding(.horizontal)

                VStack(spacing: 8) {
                    ForEach(mangas) { manga in
                        MangaProgressRow(userManga: manga, namespace: namespace)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct MangaProgressRow: View {
    @Bindable var userManga: UserManga
    let namespace: Namespace.ID
    @State private var showVolumeManagement = false

    var isFinished: Bool {
        guard let total = userManga.totalVolumes else { return false }
        return (userManga.readingVolume ?? 0) >= total
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                CoverView(
                    cover: userManga.coverURL,
                    namespace: namespace,
                    big: false
                )
                .frame(width: 60, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 6) {
                    Text(userManga.title)
                        .font(.headline)
                        .lineLimit(1)

                    if let total = userManga.totalVolumes, total > 0 {
                        let progress = Double(userManga.readingVolume ?? 0) / Double(total)

                        VStack(alignment: .leading, spacing: 4) {
                            ProgressView(value: progress)
                                .tint(isFinished ? .green : .blue)
                                .scaleEffect(y: 1.5)

                            Text("\(userManga.readingVolume ?? 0) de \(total) leídos")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Label("Tomo \(userManga.readingVolume ?? 0) leído", systemImage: "book.fill")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }

                    Button {
                        showVolumeManagement.toggle()
                    } label: {
                        Label("\(userManga.volumesOwned.count) en estantería", systemImage: "books.vertical.fill")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                Button {
                    updateReading(by: 1)
                } label: {
                    actionButton(
                        icon: isFinished ? "checkmark.seal.fill" : "plus.circle.fill",
                        text: isFinished ? "Listo" : "Leí",
                        color: isFinished ? Color.green : Color.blue
                    )
                }
                .disabled(isFinished)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .sheet(isPresented: $showVolumeManagement) {
            VolumesManagementView(userManga: userManga)
                .presentationDetents([.medium])
        }
    }

    private func updateReading(by value: Int) {
        let current = userManga.readingVolume ?? 0
        let newValue = current + value
        if newValue < 0 { return }
        if let total = userManga.totalVolumes, newValue > total { return }

        withAnimation(.easeInOut) {
            userManga.readingVolume = newValue
            if let total = userManga.totalVolumes {
                userManga.completeCollection = (newValue == total)
            }
        }
    }

    private func actionButton(icon: String, text: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 18))
            Text(text)
                .font(.system(size: 8, weight: .bold))
                .textCase(.uppercase)
        }
        .frame(width: 48, height: 44)
        .background(color.opacity(0.1))
        .foregroundStyle(color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct StatItem: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.red)
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

struct VolumesManagementView: View {
    @Bindable var userManga: UserManga
    @Environment(\.dismiss) var dismiss

    var totalVolumes: Int {
        let volumes = userManga.totalVolumes ?? (userManga.volumesOwned.max() ?? 0)
        return max(volumes, 1)
    }

    private let columns = [GridItem(.adaptive(minimum: 45))]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Selecciona los tomos físicos que posees:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(1...totalVolumes, id: \.self) { number in
                            let isOwned = userManga.volumesOwned.contains(number)
                            Button {
                                if isOwned {
                                    userManga.volumesOwned.removeAll { $0 == number }
                                } else {
                                    userManga.volumesOwned.append(number)
                                }
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
        }
    }
}
