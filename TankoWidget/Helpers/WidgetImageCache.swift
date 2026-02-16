//
//  WidgetImageCache.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import UIKit

enum WidgetImageCache {
    static func loadCover(from url: URL?) -> UIImage? {
        guard let url = url else { return nil }
        
        let fileURL = URL.cachesDirectory.appending(path: url.lastPathComponent)
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
