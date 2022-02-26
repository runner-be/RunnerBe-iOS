//
//  DetailTitleView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import SnapKit
import Then
import UIKit

final class DetailTitleView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    func setup(title: String, tag: String) {
        titleLabel.text = title
        tagLabel.text = tag
    }

    private var titleLabel = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG1
        label.text = "TITLETITLETITLE"
    }

    private var tagLabel = BadgeLabel().then { label in
        let style = BadgeLabel.Style(
            font: .iosBody13R,
            backgroundColor: .clear,
            textColor: .primarydark,
            borderWidth: 1,
            borderColor: .primarydark,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        )

        label.applyStyle(style)
        label.text = "TAGTAG"
    }

    private func setup() {
        addSubviews([
            titleLabel,
            tagLabel,
        ])
    }

    private func initialLayout() {
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(9)
            make.leading.equalTo(tagLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(-3)
        }
    }
}
