//
//  SelectionLabel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/05/08.
//

import SnapKit
import UIKit

class SelectionLabel: UIView {
    var label = UILabel()
    var icon = UIImageView()
    var iconSize: CGSize {
        didSet {
            setConstraints()
        }
    }

    var spacing: CGFloat {
        didSet {
            setConstraints()
        }
    }

    var padding: UIEdgeInsets = .zero {
        didSet {
            setConstraints()
        }
    }

    init(iconSize: CGSize = .zero, spacing: CGFloat = 0) {
        self.iconSize = iconSize
        self.spacing = spacing
        super.init(frame: .zero)

        addSubviews([label, icon])

        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        label.snp.removeConstraints()
        icon.snp.removeConstraints()

        label.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(padding.left)
            make.centerY.equalTo(self.snp.centerY)
        }

        icon.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(spacing)
            make.trailing.equalTo(self.snp.trailing).offset(-padding.right)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(iconSize.width)
            make.height.equalTo(iconSize.height)
        }
    }
}
