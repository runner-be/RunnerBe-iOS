//
//  UIImage+Resize.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/04.
//

import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
