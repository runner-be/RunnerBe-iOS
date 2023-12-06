//
//  RunnerbeSliderHandleFollower.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import UIKit

protocol SliderHandleFollower: CALayer {
    var handle: SliderHandle? { get set }
    var slider: Slider? { get set }
    func update()
    func updateColors(enable: Bool)
}
