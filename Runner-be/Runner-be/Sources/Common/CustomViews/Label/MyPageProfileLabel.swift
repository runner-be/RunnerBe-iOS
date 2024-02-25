//
//  MyPageProfileLabel.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import SnapKit
import Then
import UIKit

class MyPageProfileLabel: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2.0
    }

    enum IconPosition {
        case left, right
    }

    private let iconPosition: IconPosition

    init(iconPosition: IconPosition = .left, iconSize: CGSize = CGSize(width: 16, height: 16), spacing: CGFloat = 4, padding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)) {
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
        icon.contentMode = .center
        backgroundColor = .clear
        clipsToBounds = true
        layer.borderWidth = 0.6
        layer.borderColor = UIColor.darkG3.cgColor

        label.font = .pretendardRegular14
        label.textColor = .darkG3

        addSubviews([
            icon,
            label,
        ])
    }

    private func updateLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(30)
        }

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
