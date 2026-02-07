//
//  CoverVM.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

@Observable @MainActor
final class CoverVM {
    var image: UIImage?
    
    func getImage(cover: URL?) {
        guard let cover else { return }
        do {
            let file = ImageDownloader.shared.getFileURL(url: cover)
            if FileManager.default.fileExists(atPath: file.path()) {
                let data = try Data(contentsOf: file)
                image = UIImage(data: data)
            } else {
                Task {
                    do {
                        image = try await ImageDownloader.shared.image(for: cover)
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
