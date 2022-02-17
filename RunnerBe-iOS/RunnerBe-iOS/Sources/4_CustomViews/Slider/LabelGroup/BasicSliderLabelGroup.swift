//
//  BasicSliderLabelGroup.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/17.
//

import UIKit

class BasicSliderLabelGroup: CALayer, SliderLabelGroup {
    typealias ValueFormatter = (CGFloat) -> String

    let valueFormatter: ValueFormatter
    var minValueFormatter: ValueFormatter?
    var maxValueFormatter: ValueFormatter?

    required init?(coder: NSCoder) {
        valueFormatter = { "\($0)" }
        super.init(coder: coder)
        setup()
    }

    init(valueFormatter: @escaping ValueFormatter) {
        self.valueFormatter = valueFormatter
        super.init()
        setup()
    }

    override init(layer: Any) {
        valueFormatter = { "\($0)" }
        super.init(layer: layer)
        setup()
    }

    private func setup() {
        refresh()
    }

    weak var slider: Slider? {
        didSet {
            refresh()
        }
    }

    var spacing: CGSize = .zero
    var boxSize: CGSize = .zero

    var textFont: UIFont = .iosBody13R
    var textSize: CGFloat = 13
    var textColor: CGColor = UIColor.darkG4.cgColor
    var moduloFactor: CGFloat = 2

    func refresh() {
        guard let slider = slider, slider.separatorModulo > 0 else { return }
        sublayers?.forEach { $0.removeFromSuperlayer() }
        let maxValue = slider.maxValue
        let minValue = slider.minValue

        let modulo = slider.separatorModulo * moduloFactor

        let numberOfSeparators = Int(((maxValue - 1) - minValue) / modulo)
        let firstSeparator = minValue - CGFloat(Int(slider.minValue) % Int(modulo)) + modulo
        let separatorValues = (0 ..< numberOfSeparators).reduce(into: [CGFloat]()) { partialResult, value in
            partialResult.append(CGFloat(value) * modulo + firstSeparator)
        }

        let minText = minValueFormatter?(minValue) ?? valueFormatter(minValue)
        addLabelLayers(text: minText, toX: slider.positionInRange(of: minValue))

        separatorValues.reduce(into: [CATextLayer]()) { _, value in
            addLabelLayers(text: valueFormatter(value), toX: slider.positionInRange(of: value))
        }.forEach {
            addSublayer($0)
        }

        let maxText = maxValueFormatter?(maxValue) ?? valueFormatter(maxValue)
        addLabelLayers(text: maxText, toX: slider.positionInRange(of: maxValue))
    }

    private func addLabelLayers(text: String, toX: CGFloat) {
        let layer = CATextLayer()
        addSublayer(layer)

        layer.string = text
        layer.font = textFont as CFTypeRef
        layer.fontSize = textSize
        layer.foregroundColor = textColor
        layer.contentsScale = UIScreen.main.scale
        layer.alignmentMode = .center

        let size = NSString(string: text).size(withAttributes: [.font: textFont])
        layer.frame.size = size
        layer.position = CGPoint(
            x: toX,
            y: size.height / 2.0
        )

        frame.size.height = max(boxSize.height, size.height)
    }
}
