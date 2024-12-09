//
//  SliderValueLabel.swift
//  Runner-be
//
//  Created by 김창규 on 6/23/24.
//

import UIKit

protocol SliderValueLabel: CATextLayer {
    var handle: SliderHandle? { get set }
    var slider: Slider? { get set }
    func update()
    func updateColors(enable: Bool)
}
