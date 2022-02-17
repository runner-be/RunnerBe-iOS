//
//  JobGroupCollectionView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/10.
//

import UIKit

private let reuseIdentifier = "Cell"

final class JobGroupCollectionViewLayout: UICollectionViewFlowLayout {
    var ySpacing: CGFloat = 10
    var xSpacing: CGFloat = 10
    var contentHeight: CGFloat = 0

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect)
        else { return nil }

        var rows = [CollectionViewRow]()
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                rows.append(CollectionViewRow(spacing: xSpacing))
            }
            rows.last?.add(attribute: attribute)
        }

        contentHeight = rows.reduce(CGFloat(0)) { offsetY, collectionRow in
            collectionRow.centerLayout(
                collectionViewWidth: collectionView?.frame.width ?? 0,
                offsetY: offsetY
            )
            return offsetY + ySpacing + collectionRow.maxHeight
        }

        return rows.flatMap { $0.attributes }
    }

    override var collectionViewContentSize: CGSize {
        let size = super.collectionViewContentSize
        return CGSize(width: size.width, height: contentHeight)
    }
}

private class CollectionViewRow {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    var rowWidth: CGFloat {
        return attributes.reduce(0) { result, attribute -> CGFloat in
            result + attribute.frame.width
        } + CGFloat(attributes.count - 1) * spacing
    }

    var maxHeight: CGFloat {
        return attributes.reduce(0) { maxHeight, attribute in
            maxHeight > attribute.frame.height ? maxHeight : attribute.frame.height
        }
    }

    func centerLayout(collectionViewWidth: CGFloat, offsetY: CGFloat) {
        let padding = (collectionViewWidth - rowWidth) / 2
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = offset
            attribute.frame.origin.y = offsetY
            offset += attribute.frame.width + spacing
        }
    }
}
