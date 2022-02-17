//
//  RunnerbeSliderLabels.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/17.
//

import UIKit

protocol SliderLabelGroup: CALayer {
    var slider: Slider? { get set }
    func refresh()
}
