//
//  UIImage+Extension.swift
//  Domain
//
//  Created by 박지윤 on 7/17/25.
//

import UIKit

extension UIImage {
    public func resize(to targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
