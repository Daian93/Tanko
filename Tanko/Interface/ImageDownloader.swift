//
//  ImageDownloader.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
    public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
    import AppKit
    public typealias PlatformImage = NSImage
#endif

public actor ImageDownloader {
    public static let shared = ImageDownloader()

    private enum ImageStatus {
        case downloading(task: Task<PlatformImage, any Error>)
        case downloaded(image: PlatformImage)
    }

    private var cache: [URL: ImageStatus] = [:]

    private func getImage(url: URL) async throws -> PlatformImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = PlatformImage(data: data) {
            return image
        } else {
            throw URLError(.badServerResponse)
        }
    }

    public func image(for url: URL) async throws -> PlatformImage {
        if let status = cache[url] {
            return switch status {
            case .downloading(let task):
                try await task.value
            case .downloaded(let image):
                image
            }
        }

        let task = Task {
            try await getImage(url: url)
        }

        cache[url] = .downloading(task: task)

        do {
            let image = try await task.value
            cache[url] = .downloaded(image: image)
            try await saveImage(url: url)
            return image
        } catch {
            cache.removeValue(forKey: url)
            throw error
        }
    }

    func saveImage(url: URL) async throws {
        guard let imageCached = cache[url],
            case .downloaded(let image) = imageCached
        else { return }
        if let resized = await image.resize(width: 300) {
            #if canImport(UIKit)
                if let data = resized.pngData() {
                    try data.write(to: getFileURL(url: url), options: .atomic)
                    cache.removeValue(forKey: url)
                }
            #elseif canImport(AppKit)
                if let tiffData = resized.tiffRepresentation,
                    let bitmap = NSBitmapImageRep(data: tiffData),
                    let data = bitmap.representation(
                        using: .png,
                        properties: [:]
                    )
                {
                    try data.write(to: getFileURL(url: url), options: .atomic)
                    cache.removeValue(forKey: url)
                }
            #endif
        }
    }

    nonisolated public func getFileURL(url: URL) -> URL {
        URL.cachesDirectory.appending(path: url.lastPathComponent)
    }
}
