//
//  RunnerbeSliderProtocols.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import UIKit

class RunnerbeHandlerFollower: CALayer {
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
        addSublayer(textBox)
        addSublayer(textLayer)
        addSublayer(arrowLayer)

        textBox.frame.origin = .zero
        textLayer.frame.origin = .zero
        arrowLayer.frame.origin = .zero

        textBox.cornerRadius = textBoxCornerRadius
        textLayer.font = textFont as CFTypeRef
        textLayer.fontSize = textFontSize

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: arrowDiameter / 2.0, y: arrowDiameter))
        path.addLine(to: CGPoint(x: arrowDiameter, y: 0))
        path.close()
        arrowLayer.path = path.cgPath
        updateColors(enable: true)
        update()
    }

    var ySpacing: CGFloat = 12

    var textBox = CALayer()
    var textBoxColor: CGColor = UIColor.darkG55.cgColor
    var textBoxCornerRadius: CGFloat = 4

    var textLayer = CATextLayer()
    var textSize: CGSize = NSString(string: "00-00").size(withAttributes: [.font: UIFont.iosBody15R])
    var textFont: UIFont = .iosBody15R
    var textFontSize: CGFloat = 15
    var textEnableColor: CGColor = UIColor.primary.cgColor
    var textDisableColor: CGColor = UIColor.darkG45.cgColor
    var textPadding: UIEdgeInsets = .zero

    var arrowLayer = CAShapeLayer()
    var arrowFillColor: CGColor = UIColor.darkG55.cgColor
    var arrowStrokeColor: CGColor = UIColor.darkG55.cgColor
    var arrowDiameter: CGFloat = 8
    var arrowLineWidth: CGFloat = 1

    func updateColors(enable: Bool) {
        textBox.backgroundColor = textBoxColor
        arrowLayer.fillColor = arrowFillColor
        arrowLayer.strokeColor = arrowStrokeColor
        textLayer.foregroundColor = enable ? textEnableColor : textDisableColor
    }

    weak var slider: RunnerbeSlider?
    weak var handle: CircularHandle?

    func update() {
        guard let slider = slider else { return }
        var text = "\(Int(slider.selectedMinValue))-\(Int(slider.selectedMaxValue))"
        if slider.maxValue == slider.selectedMaxValue {
            text += "↑"
            textPadding = UIEdgeInsets(top: 3, left: 4, bottom: 3, right: 3)
        } else {
            textPadding = UIEdgeInsets(top: 3, left: 4, bottom: 3, right: 4)
        }
        textSize = NSString(string: text).size(withAttributes: [.font: textFont])
        textLayer.string = text
        textLayer.contentsScale = UIScreen.main.scale

        updatePositions()
    }

    func updatePositions() {
        guard let handle = handle else { return }

        let boxSize = CGSize(
            width: textSize.width + textPadding.left + textPadding.right,
            height: textSize.height + textPadding.top + textPadding.bottom
        )

        frame = CGRect(
            x: handle.handleSize.width / 2.0 - boxSize.width / 2.0,
            y: 0 - ySpacing - arrowDiameter - boxSize.height,
            width: boxSize.width,
            height: boxSize.height + arrowDiameter
        )

        textLayer.frame = CGRect(
            x: textPadding.left,
            y: textPadding.top,
            width: textSize.width,
            height: textSize.height
        )

        textBox.frame = CGRect(
            x: 0, y: 0,
            width: boxSize.width,
            height: boxSize.height
        )

        arrowLayer.frame = CGRect(
            x: textBox.position.x - arrowDiameter / 2.0,
            y: textBox.frame.maxY,
            width: arrowDiameter,
            height: arrowDiameter
        )
    }
}
