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

    init(iconPosition: IconPosition = .left) {
        self.iconPosition = iconPosition
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    var icon = UIImageView()
    var label = UILabel()
    private lazy var stackView: UIStackView = {
        UIStackView.make(
            with: iconPosition == .left ? [icon, label] : [label, icon],
            axis: .horizontal,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: spacing
        )
    }()

    var iconSize: CGSize = .init(width: 14, height: 14) {
        didSet {
            icon.snp.updateConstraints { make in
                make.width.equalTo(iconSize.width)
                make.height.equalTo(iconSize.height)
            }
        }
    }

    var spacing: CGFloat = 6 {
        didSet {
            stackView.spacing = spacing
        }
    }

    var padding: UIEdgeInsets = .zero {
        didSet {
            stackView.snp.updateConstraints { make in
                make.top.equalTo(self.snp.top).offset(padding.top)
                make.leading.equalTo(self.snp.leading).offset(padding.left)
                make.trailing.equalTo(self.snp.trailing).offset(-padding.right)
                make.bottom.equalTo(self.snp.bottom).offset(-padding.bottom)
            }
        }
    }

    private func setup() {
        addSubviews([
            stackView,
        ])
    }

    private func initialLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(padding.top)
            make.leading.equalTo(self.snp.leading).offset(padding.left)
            make.trailing.equalTo(self.snp.trailing).offset(-padding.right)
            make.bottom.equalTo(self.snp.bottom).offset(-padding.bottom)
        }

        icon.snp.makeConstraints { make in
            make.width.equalTo(iconSize.width)
            make.height.equalTo(iconSize.height)
        }
    }
}
