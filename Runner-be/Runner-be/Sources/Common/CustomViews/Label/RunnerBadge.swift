//
//  RunnerBadge.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import SnapKit
import Then
import UIKit

class RunnerBadge: UIView {
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

//        layer.cornerRadius = bounds.height / 2.0
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
        label.text = "초보 출석"
    }

    func setupViews() {
        layer.cornerRadius = 4
        layer.masksToBounds = true
        backgroundColor = .darkG45
        layer.borderWidth = 0

        addSubviews([
            iconView,
            label,
        ])
    }

    func initialLayout() {
        iconView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(2)
            $0.size.equalTo(14)
        }

        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconView.snp.right).offset(2)
            $0.right.equalToSuperview().inset(4)
        }
    }
}
