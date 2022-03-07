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

    init(iconPosition: IconPosition = .left, iconSize: CGSize = CGSize(width: 14, height: 14), spacing: CGFloat = 6, padding _: UIEdgeInsets = .zero) {
        self.iconPosition = iconPosition
        self.iconSize = iconSize
        self.spacing = spacing
        super.init(frame: .zero)
        setup()
        updateLayout()
    }

    var icon = UIImageView()
    var label = UILabel()
    private var iconSize: CGSize
    private var spacing: CGFloat

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
                make.leading.equalTo(self.snp.leading)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
                make.height.equalTo(iconSize.height)
                make.width.equalTo(icon.snp.height)
            }

            label.snp.makeConstraints { make in
                make.leading.equalTo(icon.snp.trailing).offset(spacing)
                make.trailing.equalTo(self.snp.trailing)
                make.centerY.equalTo(icon.snp.centerY)
            }

        case .right:
            label.snp.makeConstraints { make in
                make.leading.equalTo(self.snp.leading)
                make.centerY.equalTo(icon.snp.centerY)
            }

            icon.snp.makeConstraints { make in
                make.leading.equalTo(label.snp.trailing).offset(spacing)
                make.trailing.equalTo(self.snp.trailing)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
                make.height.equalTo(iconSize.height)
                make.width.equalTo(icon.snp.height)
            }
        }
    }
}
