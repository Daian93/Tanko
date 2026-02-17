//
//  UIImage.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

#if canImport(UIKit)
    import UIKit

    extension UIImage {
        func resize(width: CGFloat) async -> UIImage? {
            let scale = min(1, width / size.width)
            let size = CGSize(width: width, height: size.height * scale)
            return await byPreparingThumbnail(ofSize: size)
        }
    }

#elseif canImport(AppKit)
    import AppKit

    extension NSImage {
        func resize(width: CGFloat) async -> NSImage? {
            let scale = min(1, width / size.width)
            let newSize = CGSize(width: width, height: size.height * scale)

            let newImage = NSImage(size: newSize)
            newImage.lockFocus()

            let context = NSGraphicsContext.current
            context?.imageInterpolation = .high

            self.draw(
                in: NSRect(origin: .zero, size: newSize),
                from: NSRect(origin: .zero, size: self.size),
                operation: .copy,
                fraction: 1.0
            )

            newImage.unlockFocus()
            return newImage
        }
    }
#endif
