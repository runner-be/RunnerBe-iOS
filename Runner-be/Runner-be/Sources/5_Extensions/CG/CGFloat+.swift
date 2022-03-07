//
//  CGFloat+.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import UIKit

extension CGFloat {
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        if self < min {
            return min
        }

        if self > max {
            return max
        }

        return self
    }

    mutating func clamped(min: CGFloat, max: CGFloat) {
        self = clamp(min: min, max: max)
    }

    func diff(from value: CGFloat) -> CGFloat {
        return abs(self - value)
    }

    var clean: CGFloat {
        return rounded(.towardZero)
    }

    func turncate(to point: Int) -> CGFloat {
        let turncated = NSString(format: "%.\(point)f" as NSString, self)
        return CGFloat(turncated.floatValue)
    }
}
