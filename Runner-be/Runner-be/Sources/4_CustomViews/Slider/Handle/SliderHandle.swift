//
//  RunnerbeSliderHandle.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/17.
//

import UIKit

protocol SliderHandle: CALayer {
    func selected(selected: Bool)
    func updatePosition(to point: CGPoint)
    func updateColors(enable: Bool)
    var handleSize: CGSize { get }
}
