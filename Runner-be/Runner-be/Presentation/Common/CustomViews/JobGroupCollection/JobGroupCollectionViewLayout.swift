//
//  JobGroupCollectionView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/10.
//

import UIKit

final class JobGroupCollectionViewLayout: UICollectionViewFlowLayout {
    var ySpacing: CGFloat = 10
    var xSpacing: CGFloat = 10
    var contentWidth: CGFloat = 0
    var contentHeight: CGFloat = 0

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect)
        else { return nil }

        var fullWidth = collectionView?.frame.width ?? 0

        var maxWidth: CGFloat = fullWidth
        var lineMaxHeight: CGFloat = 20
        var offsetY: CGFloat = 0
        var offsetX: CGFloat = 0

        var allElements: [[UICollectionViewLayoutAttributes]] = []
        var widths: [CGFloat] = []
        var curRowElements = [UICollectionViewLayoutAttributes]()

        var needAddOffsetY = true
        for attribute in attributes {
            let diff = (offsetX + attribute.frame.width) - maxWidth

            // 끝에 도달!
            if diff > 0 {
                var added = false

                // 같은 라인에 허용 가능하면 추가하고 전체 넓이 넓히기
                if diff < xSpacing / 2 {
                    attribute.frame = CGRect(
                        x: offsetX,
                        y: offsetY,
                        width: attribute.frame.width,
                        height: attribute.frame.height
                    )
                    curRowElements.append(attribute)

                    fullWidth += diff + 1 // 부족한만큼 추가하고 소수점 고려해 + 1
                    maxWidth = max(maxWidth, fullWidth) // 전체 크기를 늘림
                    widths.append(fullWidth)
                    added = true
                } else {
                    widths.append(offsetX - xSpacing)
                }

                // 라인 바꾸고~
                allElements.append(curRowElements)
                curRowElements = []
                offsetX = 0
                offsetY = offsetY + (added ? max(lineMaxHeight, attribute.frame.height) : lineMaxHeight) + ySpacing

                if !added {
                    lineMaxHeight = attribute.frame.height
                    attribute.frame = CGRect(
                        x: offsetX,
                        y: offsetY,
                        width: attribute.frame.width,
                        height: attribute.frame.height
                    )

                    curRowElements.append(attribute)
                    offsetX = offsetX + attribute.frame.width + xSpacing
                }

                if added, attribute == attributes.last {
                    needAddOffsetY = false
                }

            } else {
                // 그냥 추가!
                attribute.frame = CGRect(
                    x: offsetX,
                    y: offsetY,
                    width: attribute.frame.width,
                    height: attribute.frame.height
                )

                offsetX = offsetX + attribute.frame.width + xSpacing
                lineMaxHeight = max(lineMaxHeight, attribute.frame.height)
                curRowElements.append(attribute)
            }
        }

        widths.append(offsetX - xSpacing)
        let fullHeight = offsetY + (needAddOffsetY ? lineMaxHeight : 0)
        allElements.append(curRowElements)
        // 가운데 정렬 작업
        for idx in 0 ..< allElements.count {
            let width = widths[idx]
            let moveX = (maxWidth - width) / 2
            allElements[idx].forEach {
                $0.frame.origin = CGPoint(x: $0.frame.origin.x + moveX, y: $0.frame.origin.y)
            }
        }

        contentWidth = fullWidth
        contentHeight = fullHeight
        return allElements.flatMap { $0 }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
}
