//
//  CircularHandle.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/17.
//

import UIKit

class CircularHandle: CAGradientLayer, SliderHandle {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        enableColors: [UIColor] = [.sliderBgBot, .sliderBgTop],
        disableColors: [UIColor] = [.darkG4, .darkG4],
        diameter: CGFloat
    ) {
        self.enableColors = enableColors.map { $0.cgColor }
        self.disableColors = disableColors.map { $0.cgColor }
        handleSize = CGSize(width: diameter, height: diameter)
        super.init()

        setup()
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    private func setup() {
        frame.origin = .zero
        frame.size = CGSize(width: handleSize.width, height: handleSize.height)
        cornerRadius = handleSize.width / 2

        updateColors(enable: true)
    }

    var handleSize: CGSize = .init(width: 16, height: 16)
    var selectedScale: CGFloat = 1.2
    private var enableColors: [CGColor] = [UIColor.sliderBgBot.cgColor, UIColor.sliderBgTop.cgColor]
    private var disableColors: [CGColor] = [UIColor.darkG4.cgColor, UIColor.darkG4.cgColor]

    func selected(selected: Bool) {
        let scaleTransform: CATransform3D
        if selected {
            scaleTransform = CATransform3DMakeScale(selectedScale, selectedScale, selectedScale)
        } else {
            scaleTransform = CATransform3DIdentity
        }

        transform = scaleTransform
    }

    func updatePosition(to point: CGPoint) {
        position = CGPoint(
            x: point.x,
            y: point.y
        )
    }

    func updateColors(enable: Bool) {
        colors = enable ? enableColors : disableColors
    }
}
