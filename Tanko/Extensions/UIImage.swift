//
//  UIImage.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//


import UIKit

extension UIImage {
    func resize(width: CGFloat) async -> UIImage? {
        let scale = min(1, width / size.width)
        let size = CGSize(width: width, height: size.height * scale)
        return await byPreparingThumbnail(ofSize: size)
    }
}
