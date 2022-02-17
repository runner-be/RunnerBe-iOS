//
//  RunnerbeSlider.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import SnapKit
import UIKit

class RunnerbeSlider: UIControl {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override var intrinsicContentSize: CGSize {
        var height = max(leftHandle.handleSize.height, rightHandle.handleSize.height, lineHeight)
        if showRightFollower {
            rightHandleFollower.update()
            height += rightHandleFollower.frame.size.height + followerSpacing
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    private func setup() {
        layer.addSublayer(lineBackground)
        layer.addSublayer(separatorBackground)
        layer.addSublayer(lineForeground)
        layer.addSublayer(leftHandle)
        layer.addSublayer(rightHandle)
        rightHandle.addSublayer(rightHandleFollower)

        lineBackground.frame = .zero
        lineForeground.frame = .zero
        rightHandleFollower.slider = self
        rightHandleFollower.handle = rightHandle
    }

    private var needLayout: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()

        if !needLayout {
            needLayout = true

            updateFixedPosition()
            updatePositions()
            rightHandleFollower.update()
            updateColors()
        }
    }

    private func updateFixedPosition() {
        let middleY: CGFloat = rightHandleFollower.frame.height + followerSpacing + lineHeight / 2.0
        let leftPos = CGPoint(x: leftHandle.handleSize.width / 2.0, y: middleY)
        let rightPos = CGPoint(x: frame.width - rightHandle.handleSize.width / 2.0, y: middleY)

        let backgroundFrame = CGRect(
            x: leftPos.x, y: middleY - lineHeight / 2.0,
            width: rightPos.x - leftPos.x,
            height: lineHeight
        )

        lineBackground.frame = backgroundFrame

        lineBackground.cornerRadius = lineHeight / 2.0
        lineForeground.cornerRadius = lineHeight / 2.0

        separatorBackground.frame = backgroundFrame
        refreshSeparators()
    }

    private func updatePositions() {
        let yPosition = lineBackground.frame.midY
        let leftPosition = CGPoint(x: positionInRange(of: selectedMinValue), y: yPosition)
        let rightPosition = CGPoint(x: positionInRange(of: selectedMaxValue), y: yPosition)
        leftHandle.updatePosition(to: leftPosition)
        rightHandle.updatePosition(to: rightPosition)

        lineForeground.frame = CGRect(
            x: leftPosition.x,
            y: lineBackground.frame.minY,
            width: rightPosition.x - leftPosition.x,
            height: lineHeight
        )
    }

    private func updateColors() {
        lineBackground.backgroundColor = lineBackgroundColor.cgColor
        lineForeground.backgroundColor = lineForegroundColor.cgColor
        leftHandle.updateColors()
        rightHandle.updateColors()
    }

    // Variables
    var maxValue: CGFloat = 100
    var minValue: CGFloat = 0
    var selectedMaxValue: CGFloat = 100
    var selectedMinValue: CGFloat = 0

    // Line Background
    var lineHeight: CGFloat = 8
    var lineBackgroundColor: UIColor = .darkG55
    var lineForegroundColor: UIColor = .primary
    var lineDisableColor: UIColor = .darkG45

    private var lineBackground: CALayer = .init()
    private var lineForeground: CALayer = .init()

    // Handle
    private var leftHandle: CircularHandle = .init(diameter: 16)
    private var rightHandle: CircularHandle = .init(diameter: 16)

    // Handler Follower
    var showRightFollower: Bool = true
    var followerSpacing: CGFloat = 12
    private var rightHandleFollower: RunnerbeHandlerFollower = .init()

    // Separator
    var separatorStepEnable: Bool = true
    var separatorModulo: CGFloat = 10
    var separatorColor: UIColor = .darkG6
    var separatorWidth: CGFloat = 2
    private var separatorBackground: CALayer = .init()

    private func refreshSeparators() {
        if separatorModulo == 0 { return }
        let numberOfSeparators = Int(((maxValue - 1) - minValue) / separatorModulo)
        let firstSeparator = minValue + (separatorModulo - CGFloat(Int(minValue) % Int(separatorModulo)))
        let separatorValues = (0 ..< numberOfSeparators).reduce(into: [CGFloat]()) { partialResult, value in
            partialResult.append(CGFloat(value) * separatorModulo + firstSeparator)
        }

        separatorBackground.sublayers?.forEach { $0.removeFromSuperlayer() }
        separatorBackground.sublayers = separatorValues.reduce(into: [CALayer]()) { partialResult, value in
            let layer = CALayer()
            layer.backgroundColor = separatorColor.cgColor
            layer.frame = CGRect(
                x: positionInRange(of: value) - separatorWidth / 2.0,
                y: 0,
                width: separatorWidth, height: lineBackground.frame.height
            )
            partialResult.append(layer)
        }
    }

    // Utils
    func percentageInRange(of value: CGFloat) -> CGFloat {
        if value < minValue || maxValue <= minValue { return 0 }
        return (value - minValue) / (maxValue - minValue)
    }

    func positionInRange(of value: CGFloat) -> CGFloat {
        let percentage = percentageInRange(of: value)
        let width = (lineBackground.frame.maxX - lineBackground.frame.minX)
        if width <= 0 { return 0 }
        let offset = width * percentage
        return offset + lineBackground.frame.minX
    }

    enum TrackingMode {
        case left, right, none
    }

    var trackingMode: TrackingMode = .none

    override func beginTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if !sensableAreaContains(point: touchPoint) {
            return false
        }

        trackingMode = trackingModeAt(point: touchPoint)

        let handle = trackingMode == .left ? leftHandle : rightHandle
        handle.selected(selected: true)
        return true
    }

    override func continueTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        if trackingMode == .none { return false }

        let touchPoint = touch.location(in: self)
        applySelectedValue(at: touchPoint, trackingMode: trackingMode)

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.12)
        updatePositions()
        rightHandleFollower.update()
        CATransaction.commit()
        return true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        if touches.count == 1,
           let touchPoint = touches.first?.location(in: self),
           sensableAreaContains(point: touchPoint)
        {
            applySelectedValue(at: touchPoint, trackingMode: trackingMode)
            updatePositions()
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.12)
            rightHandleFollower.update()
            CATransaction.commit()
        }

        let handle = trackingMode == .left ? leftHandle : rightHandle
        handle.selected(selected: false)
        trackingMode = .none
    }

    private func sensableAreaContains(point: CGPoint) -> Bool {
        let censableArea = lineBackground.frame.insetBy(dx: -30, dy: -30)
        return censableArea.contains(point)
    }

    private func valueInRange(at point: CGPoint) -> CGFloat {
        let ratioAtLine = (point.x - lineBackground.frame.minX) / (lineBackground.frame.width)
        let diffMaxMin = maxValue - minValue

        return (ratioAtLine * diffMaxMin).clamp(min: minValue, max: maxValue)
    }

    private func trackingModeAt(point: CGPoint) -> TrackingMode {
        if leftHandle.position.x.diff(from: point.x) < rightHandle.position.x.diff(from: point.x) {
            return .left
        } else {
            return .right
        }
    }

    private func applySelectedValue(at point: CGPoint, trackingMode: TrackingMode) {
        var selectedValue = valueInRange(at: point)

        if separatorStepEnable, separatorModulo != 0 {
            let remain = CGFloat(Int(selectedValue) % Int(separatorModulo))
            if remain > separatorModulo / 2.0 {
                selectedValue = (selectedValue.clean + separatorModulo - remain).clamp(min: minValue, max: maxValue)
            } else {
                selectedValue = (selectedValue.clean - remain).clamp(min: minValue, max: maxValue)
            }
        }

        switch trackingMode {
        case .left:
            selectedMinValue = min(selectedValue, maxValue)
        case .right:
            selectedMaxValue = max(selectedMinValue, selectedValue)
        case .none:
            break
        }
    }
}
