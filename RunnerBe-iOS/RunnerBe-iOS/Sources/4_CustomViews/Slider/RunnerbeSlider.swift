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

        sliderType = .range
    }

    private var needLayout: Bool = true

    override func layoutSubviews() {
        super.layoutSubviews()

        if needLayout {
            needLayout = false

            updateFixedPosition()
            updatePositions()
            rightHandleFollower.update()
            updateColors()
        }
    }

    // MARK: Variables

    enum SliderType {
        case single, range
    }

    var sliderType: SliderType = .range {
        didSet {
            switch sliderType {
            case .single:
                applySelectedValue(minValue, trackingMode: .right)
            case .range:
                applySelectedValue(minValue, trackingMode: .left)
                applySelectedValue(maxValue, trackingMode: .right)
            }
        }
    }

    var enable: Bool = true {
        didSet {
            updateColors()
        }
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
    var separatorStepEnable: Bool = false
    var separatorModulo: CGFloat = 10
    var separatorColor: UIColor = .darkG6
    var separatorWidth: CGFloat = 2
    private var separatorBackground: CALayer = .init()

    // MARK: Update & Refresh

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
        lineForeground.backgroundColor = enable ? lineForegroundColor.cgColor : lineDisableColor.cgColor
        leftHandle.updateColors(enable: enable)
        rightHandle.updateColors(enable: enable)
        rightHandleFollower.updateColors(enable: enable)
    }

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

    // MARK: Event

    enum TrackingMode {
        case left, right, none
    }

    var trackingMode: TrackingMode = .none

    override func beginTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        guard enable else { return false }

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
        if !enable || trackingMode == .none { return false }

        let touchPoint = touch.location(in: self)
        applySelectedValue(at: touchPoint, trackingMode: trackingMode)

        CATransaction.begin()
        if separatorStepEnable {
            CATransaction.setAnimationDuration(0.12)
        } else {
            CATransaction.setDisableActions(true)
        }
        updatePositions()
        rightHandleFollower.update()
        CATransaction.commit()
        return true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard enable else { return }

        if touches.count == 1,
           let touchPoint = touches.first?.location(in: self),
           sensableAreaContains(point: touchPoint)
        {
            applySelectedValue(at: touchPoint, trackingMode: trackingMode)
            updatePositions()
            rightHandleFollower.update()
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
        let width = (point.x - lineBackground.frame.minX)
        guard width != 0 else { return 0 }

        let ratioAtLine = width / lineBackground.frame.width

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

        applySelectedValue(selectedValue, trackingMode: trackingMode)
    }

    private func applySelectedValue(_ value: CGFloat, trackingMode _: TrackingMode) {
        let value = value.clamp(min: minValue, max: maxValue)
        switch trackingMode {
        case .left:
            switch sliderType {
            case .single:
                selectedMinValue = min(value, maxValue)
                selectedMaxValue = min(value, maxValue)
            case .range:
                selectedMinValue = min(value, selectedMaxValue)
            }
        case .right:
            switch sliderType {
            case .single:
                selectedMinValue = max(minValue, value)
                selectedMaxValue = max(minValue, value)
            case .range:
                selectedMaxValue = max(selectedMinValue, value)
            }
        case .none:
            break
        }
    }
}
