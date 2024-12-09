//
//  BasicSliderValueLabel.swift
//  Runner-be
//
//  Created by 김창규 on 6/23/24.
//

import UIKit

class BasicSliderValueLabel: CATextLayer, SliderValueLabel {
    override init() {
        super.init()
        setup()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        updateColors(enable: true)
        font = textFont as CFTypeRef
        fontSize = textFontSize
        foregroundColor = UIColor.darkG4.cgColor
        update()
    }

    var handle: (any SliderHandle)?

    var slider: Slider?

    var textFont: UIFont = .pretendardRegular16
    var textSize: CGSize = NSString(string: "00 - 00").size(withAttributes: [.font: UIFont.pretendardRegular16])
    var textFontSize: CGFloat = 16

    func update() {
        guard let slider = slider else { return }
        var text = "\(Int(slider.selectedMinValue))세 - \(Int(slider.selectedMaxValue))세"

        if slider.maxValue == slider.selectedMaxValue {
            text += "↑"
        }

        textSize = NSString(string: text).size(withAttributes: [.font: textFont])
        string = text
        contentsScale = UIScreen.main.scale
        updatePositions()
    }

    func updatePositions() {
        frame = CGRect(
            x: (slider?.bounds.center.x ?? 0.0) - (textSize.width / 2), // UIScreen.main.frame.width / 2.0 - frame.width / 2.0,
            y: 0, // - ySpacing - arrowDiameter - boxSize.height,
            width: textSize.width,
            height: textSize.height
        )
    }

    func updateColors(enable _: Bool) {}
}
