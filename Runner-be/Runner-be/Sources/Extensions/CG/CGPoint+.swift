//
//  CGPoint+distance.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import UIKit

extension CGPoint {
    func distance(to: CGPoint) -> CGFloat {
        let distX: CGFloat = to.x - x
        let distY: CGFloat = to.y - y
        return sqrt(distX * distX + distY * distY)
    }

    func isLeftSide(from: CGPoint) -> Bool {
        return x - from.x < 0
    }
}
