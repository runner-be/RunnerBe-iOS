//
//  SliderDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/22.
//

import UIKit

protocol SliderDelegate: AnyObject {
    func didValueChaged(_ slider: Slider, maxFrom: CGFloat, maxTo: CGFloat, minFrom: CGFloat, minTo: CGFloat)
}
