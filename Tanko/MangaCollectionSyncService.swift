import Foundation
import SwiftData

@MainActor
final class MangaCollectionSyncService {

    private let localRepo: LocalMangaCollectionRepository
    private let remoteRepo: RemoteMangaCollectionRepository

    init(
        local: LocalMangaCollectionRepository,
        remote: RemoteMangaCollectionRepository
    ) {
        self.localRepo = local
        self.remoteRepo = remote
    }

    func sync() async throws {
        let localItems = try await localRepo.getCollection()
        let remoteItems = try await remoteRepo.getCollection()

        let localByID = Dictionary(
            uniqueKeysWithValues: localItems.map { ($0.mangaID, $0) }
        )
        let remoteByID = Dictionary(
            uniqueKeysWithValues: remoteItems.map { ($0.mangaID, $0) }
        )

        let allIDs = Set(localByID.keys).union(remoteByID.keys)

        for id in allIDs {
            let local = localByID[id]
            let remote = remoteByID[id]

            do {
                switch (local, remote) {

                case (let local?, let remote?):
                    if local.updatedAt > remote.updatedAt {
                        print("⬆️ Subiendo actualización de: \(local.title)")
                        try await remoteRepo.add(mangaData: local)
                    } else if remote.updatedAt > local.updatedAt {
                        print("⬇️ Bajando actualización de: \(remote.title)")
                        try await localRepo.updateOrCreate(with: remote)
                    }

                case (let local?, nil):
                    print("⬆️ Subiendo nuevo manga: \(local.title)")
                    try await remoteRepo.add(mangaData: local)

                case (nil, let remote?):
                    print("⬇️ Descargando nuevo manga: \(remote.title)")
                    try await localRepo.updateOrCreate(with: remote)

                default:
                    break
                }
            } catch {
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .cancelled: throw NetworkError.cancelled
                    case .notConnectedToInternet: throw NetworkError.noInternet
                    case .timedOut: throw NetworkError.timedOut
                    default: throw NetworkError.general(urlError)
                    }
                } else if let nsError = error as NSError?,
                    nsError.domain == NSCocoaErrorDomain && nsError.code == 3840
                {
                    print("⚠️ Server returned OK but no JSON for manga ID: \(id)")
                    continue
                } else {
                    print("⚠️ Error syncing manga ID \(id): \(error)")
                    throw NetworkError.general(error)
                }
            }
        }
    }

    private func extractSyncData(from manga: UserManga) -> MangaSyncData {
        return MangaSyncData(
            mangaID: manga.mangaID,
            title: manga.title,
            coverURL: manga.coverURL,
            totalVolumes: manga.totalVolumes,
            volumesOwned: manga.volumesOwned,
            readingVolume: manga.readingVolume,
            completeCollection: manga.completeCollection,
            updatedAt: manga.updatedAt
        )
    }
}

struct MangaSyncData {
    let mangaID: Int
    let title: String
    let coverURL: URL?
    let totalVolumes: Int?
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
    let updatedAt: Date
}
