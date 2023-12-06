//
//  OnOffLabel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import RxCocoa
import RxGesture
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
}
