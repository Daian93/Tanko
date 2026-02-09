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
                }
            }
            .navigationTitle("Mi Biblioteca")
            .backgroundStyle(AppColors.primary)
        }
    }

    private var headerView: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.red.opacity(0.1))
                .frame(width: 70, height: 70)
                .overlay(Text("DR").font(.headline).foregroundStyle(.red))

            VStack(alignment: .leading) {
                Text("Mi Perfil")
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
                        let progress =
                            Double(userManga.readingVolume ?? 0) / Double(total)

                        VStack(alignment: .leading, spacing: 4) {
                            ProgressView(value: progress)
                                .tint(isFinished ? .green : .blue)
                                .scaleEffect(y: 1.5)

                            Text(
                                "\(userManga.readingVolume ?? 0) de \(total) leídos"
                            )
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                    } else {
                        Label(
                            "Tomo \(userManga.readingVolume ?? 0) leído",
                            systemImage: "book.fill"
                        )
                        .font(.caption)
                        .foregroundStyle(.blue)
                    }

                    Button {
                        showVolumeManagement.toggle()
                    } label: {
                        Label(
                            "\(userManga.volumesOwned.count) en estantería",
                            systemImage: "books.vertical.fill"
                        )
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
                    increaseReadingProgress()
                } label: {
                    actionButton(
                        icon: isFinished
                            ? "checkmark.seal.fill" : "plus.circle.fill",
                        text: isFinished ? "Listo" : "Leí",
                        color: isFinished ? Color.green : Color.blue
                    )
                }
                .disabled(isFinished)
                .opacity(isFinished ? 0.6 : 1.0)
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

    private func increaseReadingProgress() {
        let nextVolume = (userManga.readingVolume ?? 0) + 1

        if let total = userManga.totalVolumes {
            if nextVolume <= total {
                userManga.readingVolume = nextVolume
            }

            if nextVolume == total {
                withAnimation(.spring()) {
                    userManga.completeCollection = true
                }
            }
        } else {
            userManga.readingVolume = nextVolume
        }
    }

    struct MangaProgressRow: View {
        @Bindable var userManga: UserManga
        let namespace: Namespace.ID
        @State private var showVolumeManagement = false

        var body: some View {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
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
                            let progress =
                                Double(userManga.readingVolume ?? 0)
                                / Double(total)
                            VStack(alignment: .leading, spacing: 4) {
                                ProgressView(value: progress)
                                    .tint(
                                        (userManga.readingVolume ?? 0) >= total
                                            ? .green : .blue
                                    )
                                Text(
                                    "\(userManga.readingVolume ?? 0) / \(total) leídos"
                                )
                                .font(.caption2).foregroundStyle(.secondary)
                            }
                        } else {
                            Text("Tomo actual: \(userManga.readingVolume ?? 0)")
                                .font(.caption2).foregroundStyle(.blue)
                        }

                        Button {
                            showVolumeManagement.toggle()
                        } label: {
                            Label(
                                "\(userManga.volumesOwned.count) en estantería",
                                systemImage: "books.vertical.fill"
                            )
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                        }
                    }

                    Spacer()

                    HStack(spacing: 8) {

                        VStack(spacing: 4) {
                            Text("LEER").font(.system(size: 7, weight: .black))
                                .foregroundStyle(.blue)
                            HStack(spacing: 0) {
                                Button {
                                    updateReading(by: -1)
                                } label: {
                                    Image(systemName: "minus").font(
                                        .system(size: 10, weight: .bold)
                                    )
                                    .frame(width: 25, height: 30)
                                    .background(Color.blue.opacity(0.1))
                                }

                                Divider().frame(height: 20)

                                Button {
                                    updateReading(by: 1)
                                } label: {
                                    Image(systemName: "plus").font(
                                        .system(size: 10, weight: .bold)
                                    )
                                    .frame(width: 25, height: 30)
                                    .background(Color.blue.opacity(0.1))
                                }
                            }
                            .foregroundStyle(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        VStack(spacing: 4) {
                            Text("TENER").font(.system(size: 7, weight: .black))
                                .foregroundStyle(.green)
                            Button {
                                let nextToOwn =
                                    (userManga.volumesOwned.max() ?? 0) + 1
                                userManga.volumesOwned.append(nextToOwn)
                            } label: {
                                Image(systemName: "plus.app.fill")
                                    .font(.system(size: 18))
                                    .frame(width: 44, height: 30)
                                    .background(Color.green.opacity(0.1))
                                    .foregroundStyle(.green)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                        }
                    }
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
    }

    private func actionButton(icon: String, text: String, color: Color)
        -> some View
    {
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
        let volumes =
            userManga.totalVolumes ?? (userManga.volumesOwned.max() ?? 0)
        return max(volumes, 1)
    }

    private let columns = [
        GridItem(.adaptive(minimum: 45))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Colección de \(userManga.title)")
                        .font(.headline)
                        .padding(.horizontal)

                    Text("Selecciona los tomos físicos que posees:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(1...totalVolumes, id: \.self) { number in

                            let isOwned = userManga.volumesOwned.contains(
                                number
                            )

                            Button {
                                if isOwned {
                                    userManga.volumesOwned.removeAll {
                                        $0 == number
                                    }
                                } else {
                                    userManga.volumesOwned.append(number)
                                }
                            } label: {
                                Text("\(number)")
                                    .font(
                                        .system(.subheadline, design: .rounded)
                                            .bold()
                                    )
                                    .frame(width: 45, height: 45)
                                    .background(
                                        isOwned
                                            ? Color.green
                                            : Color(.secondarySystemBackground)
                                    )
                                    .foregroundStyle(
                                        isOwned ? .white : .primary
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
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

#Preview(traits: .sampleData) {
    ProfileView()
}
