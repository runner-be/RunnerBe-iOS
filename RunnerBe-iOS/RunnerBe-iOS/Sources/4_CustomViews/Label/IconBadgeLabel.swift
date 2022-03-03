//
//  IconBadgeLabel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import SnapKit
import Then
import UIKit

class IconBadgeLabel: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2.0
    }

    var padding: UIEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 7)

    var iconView = UIImageView().then { view in
        view.image = Asset.smile.uiImage
        view.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
    }

    var label = UILabel().then { label in
        label.font = .iosCaption11R
        label.textColor = .darkG25
        label.text = "성실러너"
    }

    func setupViews() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.darkG25.cgColor

        addSubviews([
            iconView,
            label,
        ])
    }

    func initialLayout() {
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(iconView.snp.height)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(2)
            make.trailing.equalTo(self.snp.trailing).offset(-padding.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
