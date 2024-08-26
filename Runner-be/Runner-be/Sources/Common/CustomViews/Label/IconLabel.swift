//
//  IconLabel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import SnapKit
import Then
import UIKit

class IconLabel: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum IconPosition {
        case left, right
    }

    private let iconPosition: IconPosition

    init(
        iconPosition: IconPosition = .left,
        iconSize: CGSize = CGSize(width: 14, height: 14),
        spacing: CGFloat = 6,
        padding: UIEdgeInsets = .zero
    ) {
        self.iconPosition = iconPosition
        self.iconSize = iconSize
        self.spacing = spacing
        self.padding = padding
        super.init(frame: .zero)
        setup()
        updateLayout()
    }

    var icon = UIImageView()
    var label = UILabel()
    private var iconSize: CGSize
    private var spacing: CGFloat
    private var padding: UIEdgeInsets

    private func setup() {
        icon.contentMode = .scaleAspectFit

        addSubviews([
            icon,
            label,
        ])
    }

    private func updateLayout() {
        icon.layer.cornerRadius = iconSize.height / 2.0
        icon.clipsToBounds = true

        switch iconPosition {
        case .left:
            icon.snp.makeConstraints { make in
                make.leading.equalTo(self.snp.leading).offset(padding.left)
                make.top.equalTo(self.snp.top).offset(padding.top)
                make.bottom.equalTo(self.snp.bottom).offset(-padding.bottom)
                make.height.equalTo(iconSize.height)
                make.width.equalTo(iconSize.width)
            }

            label.snp.makeConstraints { make in
                make.leading.equalTo(icon.snp.trailing).offset(spacing)
                make.trailing.equalTo(self.snp.trailing).offset(-padding.right)
                make.centerY.equalTo(icon.snp.centerY)
            }

        case .right:
            label.snp.makeConstraints { make in
                make.leading.equalTo(self.snp.leading).offset(padding.left)
                make.centerY.equalTo(icon.snp.centerY)
            }

            icon.snp.makeConstraints { make in
                make.leading.equalTo(label.snp.trailing).offset(spacing)
                make.trailing.equalTo(self.snp.trailing).offset(-padding.right)
                make.top.equalTo(self.snp.top).offset(padding.top)
                make.bottom.equalTo(self.snp.bottom).offset(-padding.bottom)
                make.height.equalTo(iconSize.height)
                make.width.equalTo(icon.snp.height)
            }
        }
    }
}

extension IconLabel {
    static func Size(iconSize: CGSize, text: String, font: UIFont, spacing: CGFloat, padding: UIEdgeInsets = .zero) -> CGSize {
        let labelSize = NSString(string: text).size(withAttributes: [.font: font])

        let width = iconSize.width + spacing + labelSize.width + padding.left + padding.right
        let height = max(iconSize.height, labelSize.height) + padding.top + padding.bottom

        return CGSize(width: width, height: height)
    }
}
