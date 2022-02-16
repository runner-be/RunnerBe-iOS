//
//  RunnerbeSlider.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

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

    private func setup() {
        layer.addSublayer(lineBackground)
        layer.addSublayer(separatorBackground)
        layer.addSublayer(foregroundBar)

        leftHandle.cornerRadius = handleDiameter / 2.0
        rightHandle.cornerRadius = handleDiameter / 2.0
        let handleFrame = CGRect(x: 0.0, y: 0.0, width: handleDiameter, height: handleDiameter)
        leftHandle.frame = handleFrame
        rightHandle.frame = handleFrame

        layer.addSublayer(leftHandle)
        layer.addSublayer(rightHandle)

        refresh()
    }

    enum SliderType {
        case single
        case range
    }

    // MARK: accessible properties

    var type: SliderType = .range
    var automaticalyMoveToSeparator: Bool = true

    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 100.0

    var selectedMinValue: CGFloat = 0.0 {
        didSet { selectedMinValue.clamped(min: minValue, max: selectedMaxValue) }
    }

    var selectedMaxValue: CGFloat = 100.0 {
        didSet { selectedMaxValue.clamped(min: selectedMinValue, max: maxValue) }
    }

    var separatorValues: [CGFloat] = [10, 20, 30, 40, 50, 60, 70, 80]

    // MARK: Colors

    var separatorColor: CGColor = UIColor.darkG6.cgColor {
        didSet { updateColors() }
    }

    var handleDisableColors: [CGColor] = [UIColor.darkG4.cgColor, UIColor.darkG4.cgColor] {
        didSet { updateColors() }
    }

    var handleEnableColors: [CGColor] = [UIColor.sliderBgBot.cgColor, UIColor.sliderBgTop.cgColor] {
        didSet { updateColors() }
    }

    var rangeEnableColor: UIColor = .primary {
        didSet { updateColors() }
    }

    var rangeDisableColor: UIColor = .darkG45 {
        didSet { updateColors() }
    }

    var rangeBackgroundColor: UIColor = .darkG55 {
        didSet { updateColors() }
    }

    // MARK: Size

    var backgroundBarHeight: CGFloat = 8 {
        didSet { updateBarHeight() }
    }

    var foregroundBarHeight: CGFloat = 8 {
        didSet { updateBarHeight() }
    }

    var separatorWidth: CGFloat = 2 {
        didSet { updateSeparators() }
    }

    var enable: Bool = true {
        didSet { updateColors() }
    }

    var handleDiameter: CGFloat = 16 {
        didSet {
            leftHandle.cornerRadius = handleDiameter / 2.0
            rightHandle.cornerRadius = handleDiameter / 2.0
            leftHandle.frame = CGRect(x: 0, y: 0, width: handleDiameter, height: handleDiameter)
            rightHandle.frame = CGRect(x: 0, y: 0, width: handleDiameter, height: handleDiameter)
        }
    }

    private var leftHandle = CAGradientLayer() {
        didSet {
            updateColors()
        }
    }

    private var rightHandle = CAGradientLayer() {
        didSet {
            updateColors()
        }
    }

    private var lineBackground = CALayer() {
        didSet {
            updateColors()
        }
    }

    private var foregroundBar = CALayer() {
        didSet {
            updateColors()
        }
    }

    private var separatorBackground = CALayer()

    private var separators = [CALayer]()

    override var intrinsicContentSize: CGSize {
        let height = leftHandle.frame.height

        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if trackingType == .none {
            if separators.count != separatorValues.count {
                setupSeparators()
            }

            updateBarHeight()
            updateColors()
            updateHandlePositions()
            updateSeparators()
        }
    }

    // MARK: Updates

    private func refresh() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.12)
        updateHandlePositions()
        CATransaction.commit()
        updateColors()
    }

    private func updateHandlePositions() {
        leftHandle.position = CGPoint(
            x: xPositionInRange(for: selectedMinValue),
            y: lineBackground.frame.midY
        )

        rightHandle.position = CGPoint(
            x: xPositionInRange(for: selectedMaxValue),
            y: lineBackground.frame.midY
        )

        // positioning for the dist slider line
        foregroundBar.frame = CGRect(
            x: leftHandle.position.x,
            y: lineBackground.frame.minY,
            width: rightHandle.position.x - leftHandle.position.x,
            height: foregroundBarHeight
        )
    }

    private func updateBarHeight() {
        let barSidePadding: CGFloat = handleDiameter / 2.0
        let yMiddle: CGFloat = frame.height / 2.0
        let barLeftSide = CGPoint(x: barSidePadding, y: yMiddle)
        let barRightSide = CGPoint(x: frame.width - barSidePadding,
                                   y: yMiddle)
        lineBackground.frame = CGRect(x: barLeftSide.x,
                                      y: yMiddle - backgroundBarHeight,
                                      width: barRightSide.x - barLeftSide.x,
                                      height: backgroundBarHeight)
        lineBackground.cornerRadius = backgroundBarHeight / 2.0
        foregroundBar.cornerRadius = lineBackground.cornerRadius

        separators.forEach {
            $0.frame = CGRect(x: $0.frame.origin.x, y: lineBackground.frame.origin.y, width: $0.frame.width, height: backgroundBarHeight)
        }
    }

    private func updateColors() {
        lineBackground.backgroundColor = rangeBackgroundColor.cgColor
        leftHandle.backgroundColor = UIColor.white.cgColor
        rightHandle.backgroundColor = UIColor.white.cgColor

        if enable {
            leftHandle.colors = handleEnableColors
            rightHandle.colors = handleEnableColors
            foregroundBar.backgroundColor = rangeEnableColor.cgColor
        } else {
            leftHandle.colors = handleDisableColors
            rightHandle.colors = handleDisableColors
            foregroundBar.backgroundColor = rangeDisableColor.cgColor
        }

        separators.forEach {
            $0.backgroundColor = separatorColor
        }
    }

    private func updateSeparators() {
        guard !separatorValues.isEmpty
        else { return }

        for (idx, separator) in separators.enumerated() {
            let value = separatorValues[idx]
            let posX = xPositionInRange(for: value - separatorWidth / 2.0)
            let posY = separator.frame.origin.y
            separator.frame = CGRect(x: posX, y: posY, width: separatorWidth, height: backgroundBarHeight)
        }
    }

    private func setupSeparators() {
        separators.forEach { $0.removeFromSuperlayer() }
        separators.removeAll()

        if !separatorValues.isEmpty {
            for _ in 0 ..< separatorValues.count {
                let layer = CALayer()
                separatorBackground.addSublayer(layer)
                separators.append(layer)
            }
        }
    }

    // MARK: Tracking

    enum TrackingType {
        case left
        case right
        case none
    }

    private var trackingType: TrackingType = .none

    override func beginTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        if !enable {
            trackingType = .none
            return false
        }

        let touchPoint = touch.location(in: self)
        let noticableRect = bounds.insetBy(dx: -30, dy: -100)
        let handleTouched = noticableRect.contains(touchPoint)

        if !handleTouched {
            trackingType = .none
            return false
        }

        let distanceFromLeft: CGFloat = touchPoint.distance(to: leftHandle.frame.center)
        let distanceFromRight: CGFloat = touchPoint.distance(to: rightHandle.frame.center)

        switch type {
        case .single:
            trackingType = touchPoint.isLeftSide(from: leftHandle.frame.center) ? .left : .right
        case .range:
            if distanceFromLeft == distanceFromRight {
                if touchPoint.isLeftSide(from: leftHandle.frame.center) {
                    trackingType = .left
                } else {
                    trackingType = .right
                }
            } else if distanceFromLeft < distanceFromRight {
                trackingType = .left
            } else {
                trackingType = .right
            }
        }

        let handle = trackingType == .left ? leftHandle : rightHandle
        selectAnimation(handle: handle, selected: true)
        updateSelectedValue(position: touchPoint)
        return true
    }

    override func continueTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        guard trackingType != .none else { return false }

        let touchPoint = touch.location(in: self)
        updateSelectedValue(position: touchPoint)

        return true
    }

    override func endTracking(_: UITouch?, with _: UIEvent?) {
        guard trackingType != .none else { return }
        let handle = trackingType == .left ? leftHandle : rightHandle
        selectAnimation(handle: handle, selected: false)
        trackingType = .none
    }

    private func updateSelectedValue(position: CGPoint) {
        let percentage = (position.x - lineBackground.frame.minX) / (lineBackground.frame.maxX - lineBackground.frame.minX)
        let currentValue = (percentage * (maxValue - minValue) + minValue).clamp(min: minValue, max: maxValue)

        let targetValue: CGFloat

        if automaticalyMoveToSeparator {
            let value = separatorValues.reduce(minValue) { currentValue - $0 < $1 - currentValue ? $0 : $1 }
            targetValue = (currentValue - value < maxValue - currentValue) ? value : maxValue
        } else {
            targetValue = currentValue
        }

        switch type {
        case .single:
            selectedMaxValue = targetValue
            selectedMinValue = targetValue
        case .range:
            switch trackingType {
            case .left:
                selectedMinValue = targetValue.clamp(min: minValue, max: selectedMaxValue)
            case .right:
                selectedMaxValue = targetValue.clamp(min: selectedMinValue, max: maxValue)
            case .none:
                break
            }
        }

        refresh()
    }

    private func selectAnimation(handle: CALayer, selected: Bool) {
        let transform = selected ? CATransform3DMakeScale(1.2, 1.2, 1) : CATransform3DIdentity

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        handle.transform = transform

        CATransaction.commit()
    }

    private func percentageInRange(for value: CGFloat) -> CGFloat {
        guard minValue < maxValue else { return 0.0 }
        return (value - minValue) / (maxValue - minValue)
    }

    private func xPositionInRange(for value: CGFloat) -> CGFloat {
        let percentage: CGFloat = percentageInRange(for: value)
        let maxMinDif: CGFloat = lineBackground.frame.maxX - lineBackground.frame.minX
        let offset: CGFloat = percentage * maxMinDif
        return lineBackground.frame.minX + offset
    }
}
