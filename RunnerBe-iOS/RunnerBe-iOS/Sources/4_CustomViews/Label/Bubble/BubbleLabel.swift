//
//  BubbleLabel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/22.
//

import UIKit

class BubbleLabel: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum Direction {
        case left, right
    }

    var direction: Direction

    var padding: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    var texts: [String] = [""] {
        didSet {
            textLayer.string = texts.joined(separator: "\n")
            updateTextBox()
            invalidateIntrinsicContentSize()
        }
    }

    var fontSize: CGFloat = 13 {
        didSet {
            textLayer.fontSize = fontSize
            updateTextBox()
            invalidateIntrinsicContentSize()
        }
    }

    var font: UIFont = .iosBody13R {
        didSet {
            textLayer.font = font as CFTypeRef
            textLayer.fontSize = fontSize
            updateTextBox()
            invalidateIntrinsicContentSize()
        }
    }

    var textColor: UIColor = .darkG1 {
        didSet {
            updateColors()
        }
    }

    private var textSize: CGSize = .zero
    private var textLayer = CATextLayer()

    var bubbleColor: UIColor = .darkG6
    var bubbleBorderColor: UIColor = .darkG6
    var bubbleLineWidth: CGFloat = 0
    var bubbleLayer = CAShapeLayer()

    init(direction: Direction) {
        self.direction = direction
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        layer.addSublayer(bubbleLayer)
        layer.addSublayer(textLayer)
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.isWrapped = true
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: textSize.width + padding.left + padding.right,
                      height: textSize.height + padding.top + padding.bottom)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateBubblePath()
        updateColors()
    }

    private func updateTextBox() {
        let font = font.withSize(fontSize)
        textSize = texts.reduce(CGSize(width: 0, height: 0)) { partialResult, text in
            let nsText = NSString(string: text)
            let boxSize = nsText.size(withAttributes: [.font: font])
            return CGSize(
                width: max(partialResult.width, boxSize.width),
                height: partialResult.height + boxSize.height
            )
        }

        textLayer.frame = CGRect(
            x: padding.left,
            y: padding.top,
            width: textSize.width,
            height: textSize.height
        )
    }

    private func updateBubblePath() {
        let path = UIBezierPath()
        let minX: CGFloat = 0
        let maxX: CGFloat = bounds.maxX
        let minY: CGFloat = 0
        let maxY: CGFloat = bounds.maxY

        path.move(to: CGPoint(x: minX + padding.left, y: minY))

        // rightTop
        path.addLine(to: CGPoint(x: maxX - padding.right, y: minY))

        // rightTop Corner
        let cp1 = CGPoint(x: maxX, y: minY)
        path.addCurve(to: CGPoint(x: maxX, y: padding.top), controlPoint1: cp1, controlPoint2: cp1)

        switch direction {
        case .left:
            // rightBottom
            path.addLine(to: CGPoint(x: maxX, y: maxY - padding.bottom))
            // rightBottom corner
            let cp2 = CGPoint(x: maxX, y: maxY)
            path.addCurve(to: CGPoint(x: maxX - padding.right, y: maxY), controlPoint1: cp2, controlPoint2: cp2)

            // to leftBottom
            path.addLine(to: CGPoint(x: minX, y: maxY))
        case .right:
            // rightBottom
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            // leftBottom
            path.addLine(to: CGPoint(x: padding.left, y: maxY))
            // leftBottom Corner
            let cp3 = CGPoint(x: minX, y: maxY)
            path.addCurve(to: CGPoint(x: minX, y: maxY - padding.bottom), controlPoint1: cp3, controlPoint2: cp3)
        }

        // leftTop
        path.addLine(to: CGPoint(x: minY, y: padding.top))
        // leftTopCorner
        let cp4 = CGPoint(x: minX, y: minY)
        path.addCurve(to: CGPoint(x: padding.left, y: minY), controlPoint1: cp4, controlPoint2: cp4)

        bubbleLayer.path = path.cgPath
    }

    private func updateColors() {
        bubbleLayer.lineWidth = bubbleLineWidth
        bubbleLayer.fillColor = bubbleColor.cgColor
        bubbleLayer.strokeColor = bubbleBorderColor.cgColor
        textLayer.foregroundColor = textColor.cgColor
    }
}
