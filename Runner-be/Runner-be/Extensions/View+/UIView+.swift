//
//  UIView+.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
