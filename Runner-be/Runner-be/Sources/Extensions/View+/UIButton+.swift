//
//  UIButton+.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/06.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(backgroundImage, for: state)
    }
}
