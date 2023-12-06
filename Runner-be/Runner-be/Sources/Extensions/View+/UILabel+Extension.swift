//
//  UILabel+Extension.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/24.
//

import UIKit

extension UILabel {
    func setTextWithLineHeight(text: String, with height: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = height
        style.minimumLineHeight = height

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (height - font.lineHeight) / 4,
        ]

        let attrString = NSAttributedString(string: text, attributes: attributes)

        attributedText = attrString
    }
}
