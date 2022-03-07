//
//  BadgeLabel.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import UIKit

class BadgeLabel: UILabel {
    struct Style {
        var font: UIFont?
        var backgroundColor: UIColor = .clear
        var textColor: UIColor = .label
        var borderWidth: CGFloat = 0
        var borderColor: UIColor = .clear
        var cornerRadiusRatio: CGFloat = 0
        var useCornerRadiusAsFactor: Bool = true
        var padding: UIEdgeInsets = .zero
    }

    var cornerRadiusRatio: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var padding: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    init() {
        super.init(frame: .zero)
        textAlignment = .center
    }

    init(text: String) {
        super.init(frame: .zero)
        textAlignment = .center
        self.text = text
        clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let original = super.intrinsicContentSize
        return CGSize(width: original.width + padding.left + padding.right,
                      height: original.height + padding.top + padding.bottom)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height * (cornerRadiusRatio / 2.0)
    }

    func applyStyle(_ style: BadgeLabel.Style) {
        font = style.font
        textColor = style.textColor
        layer.backgroundColor = style.backgroundColor.cgColor
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor.cgColor
        if style.useCornerRadiusAsFactor {
            cornerRadiusRatio = style.cornerRadiusRatio
            layer.cornerRadius = 0
        } else {
            layer.cornerRadius = style.cornerRadiusRatio
            cornerRadiusRatio = 0
        }
        padding = style.padding
        invalidateIntrinsicContentSize()
    }
}
