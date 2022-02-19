//
//  SegmentedControl.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import UIKit

class SegmentedControl: UIControl {
    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    private func setup() {
        layer.addSublayer(defaultItemContainer)
        layer.addSublayer(highlightLayer)
        layer.masksToBounds = true
        defaultItemContainer.masksToBounds = true
        highlightLayer.masksToBounds = true
        refreshItems()
        updateColors()
    }

    // MARK: Accessible Value

    var fontSize: CGFloat = 15
    var defaultTextFont: UIFont = .iosBody15R
    var highlightTextFont: UIFont = .iosBody15B
    var defaultTextColor: UIColor = .label
    var highlightTextColor: UIColor = .red

    var boxColors: [UIColor] = [.darkG6]
    var highlightBoxColors: [UIColor] = [.black]

    var boxPadding: UIEdgeInsets = .zero
    var highlightBoxPadding: UIEdgeInsets = .zero
    var useCornerRadiusAsRatio: Bool = true
    var cornerRadiusFactor: CGFloat = 1

    var selectedItem: Int = 0
    var items: [String] = ["item0", "item1", "item2"]

    var highlightOffset: CGFloat = 0

    // MARK: Layers

    private var itemSize: CGSize = .zero
    private var textHeight: CGFloat = 15
    private var defaultItemContainer = CAGradientLayer()

    private var itemLayers: [[CATextLayer]] = []
    private var highlightLayer = CAGradientLayer()

    // MARK: Overrides

    var needsLayout = true
    override func layoutSubviews() {
        super.layoutSubviews()

        if needsLayout {
            needsLayout = false
            refreshItems()
            updatesFixedPositions()
            updateContainerPositions()
            updateColors()
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let height = size.height + textHeight + boxPadding.top + boxPadding.bottom
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    // MARK: Updates

    private func updatesFixedPositions() {
        defaultItemContainer.frame = bounds

        let numItem = items.count
        itemSize = CGSize(width: bounds.width / CGFloat(numItem), height: bounds.height)
        _ = itemLayers.reduce(CGFloat(0)) { offsetX, layer in
            layer[0].frame = CGRect(x: offsetX, y: boxPadding.top, width: itemSize.width, height: itemSize.height)
            layer[1].frame = CGRect(x: offsetX, y: boxPadding.top, width: itemSize.width, height: itemSize.height)
            return offsetX + itemSize.width
        }

        highlightLayer.frame.size = itemSize

        let cornerRadius = useCornerRadiusAsRatio ?
            itemSize.height * cornerRadiusFactor / 2.0 : cornerRadiusFactor

        highlightLayer.cornerRadius = cornerRadius
        defaultItemContainer.cornerRadius = cornerRadius
    }

    private func updateContainerPositions() {
        let positionX = itemSize.width * CGFloat(selectedItem)

        highlightLayer.frame = CGRect(
            x: positionX,
            y: highlightLayer.frame.minY,
            width: itemSize.width,
            height: itemSize.height
        )

        _ = itemLayers.reduce(CGFloat(-positionX)) { offsetX, layer in
            layer[1].frame = CGRect(x: offsetX, y: boxPadding.top, width: itemSize.width, height: itemSize.height)
            return offsetX + itemSize.width
        }
    }

    private func updateColors() {
        if boxColors.count == 1 {
            defaultItemContainer.colors = [boxColors[0].cgColor, boxColors[0].cgColor]
        } else {
            defaultItemContainer.colors = boxColors.reduce(into: [CGColor]()) { $0.append($1.cgColor) }
        }
        if highlightBoxColors.count == 1 {
            highlightLayer.colors = [highlightBoxColors[0].cgColor, highlightBoxColors[0].cgColor]
        } else {
            highlightLayer.colors = highlightBoxColors.reduce(into: [CGColor]()) { $0.append($1.cgColor) }
        }

        itemLayers.forEach { layer in
            layer[0].foregroundColor = defaultTextColor.cgColor
            layer[1].foregroundColor = highlightTextColor.cgColor
        }
    }

    private func refreshItems() {
        itemLayers = items.reduce(into: [[CATextLayer]]()) { partialResult, item in
            let defaultTextLayer = CATextLayer()
            defaultItemContainer.addSublayer(defaultTextLayer)
            defaultTextLayer.font = defaultTextFont as CFTypeRef
            defaultTextLayer.fontSize = fontSize
            defaultTextLayer.foregroundColor = defaultTextColor.cgColor
            defaultTextLayer.contentsScale = UIScreen.main.scale
            defaultTextLayer.alignmentMode = .center
            defaultTextLayer.string = item
            let highlightTextLayer = CATextLayer()
            highlightLayer.addSublayer(highlightTextLayer)
            highlightTextLayer.font = highlightTextFont as CFTypeRef
            highlightTextLayer.fontSize = 15
            highlightTextLayer.foregroundColor = highlightTextColor.cgColor
            highlightTextLayer.contentsScale = UIScreen.main.scale
            highlightTextLayer.alignmentMode = .center
            highlightTextLayer.string = item

            partialResult.append([defaultTextLayer, highlightTextLayer])
            let defaultTextHeight = NSString(string: item).size(withAttributes: [.font: defaultTextFont]).height
            let highlightTextHeight = NSString(string: item).size(withAttributes: [.font: highlightTextFont]).height
            textHeight = max(textHeight, defaultTextHeight, highlightTextHeight)
        }
    }

    // MARK: Touch Event

    enum TrackingType {
        case toLeft, toRight, none
    }

    private var trackingType: TrackingType = .none

    override func beginTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if !sensableAreaContains(point: touchPoint) {
            return false
        }

        trackingType = trackingModeAt(point: touchPoint)
        return true
    }

    override func continueTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        if trackingType == .none { return false }

        let touchPoint = touch.location(in: self)
        applySelectedItem(at: touchPoint)

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.12)
//        CATransaction.setDisableActions(true)
        updateContainerPositions()
        CATransaction.commit()

        return true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        if touches.count == 1,
           let touchPoint = touches.first?.location(in: self),
           sensableAreaContains(point: touchPoint)
        {
            applySelectedItem(at: touchPoint)
            updateContainerPositions()
        }

        trackingType = .none
    }

    private func sensableAreaContains(point: CGPoint) -> Bool {
        return defaultItemContainer.contains(point)
    }

    private func trackingModeAt(point: CGPoint) -> TrackingType {
        let centerXSelectedItem = itemSize.width * CGFloat(selectedItem) + itemSize.width / 2.0

        if point.x < centerXSelectedItem {
            return .toLeft
        } else {
            return .toRight
        }
    }

    private func applySelectedItem(at point: CGPoint) {
        selectedItem = itemInRange(at: point)
        highlightOffset = (point.x - itemSize.width / 2.0).clamp(min: 0, max: CGFloat(items.count - 1) * itemSize.width)
    }

    private func itemInRange(at point: CGPoint) -> Int {
//        return Int((point.x + itemSize.width / 2.0) / itemSize.width)
        return Int((point.x) / itemSize.width)
    }
}
