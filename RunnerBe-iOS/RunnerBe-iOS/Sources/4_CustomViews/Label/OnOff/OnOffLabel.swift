//
//  ActivableBadgeLabel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import RxCocoa
import RxSwift
import UIKit

class OnOffLabel: BadgeLabel {
    enum State {
        case on, off
    }

    var styleOn = Style() {
        didSet {
            if isOn { applyStyle(styleOn) }
        }
    }

    var styleOff = Style() {
        didSet {
            if !isOn { applyStyle(styleOff) }
        }
    }

    var isOn = false {
        didSet {
            let style: Style = isOn ? styleOn : styleOff
            applyStyle(style)
            setNeedsDisplay()
        }
    }

    private func applyStyle(_ style: BadgeLabel.Style) {
        font = style.font
        textColor = style.textColor
        backgroundColor = style.backgroundColor
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor.cgColor
        cornerRadiusRatio = style.cornerRadiusRatio
        padding = style.padding
    }
}
