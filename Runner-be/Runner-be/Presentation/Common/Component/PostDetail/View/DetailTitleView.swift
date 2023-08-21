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
        initialLayout(finished: false)
    }

    func setup(title: String, tag: String, finished: Bool) {
        titleLabel.text = title
        tagLabel.text = tag
        tagLabel.applyStyle(
            BadgeLabel.Style(
                font: .iosBody13R,
                backgroundColor: .clear,
                textColor: .primarydark,
                borderWidth: 1,
                borderColor: .primarydark,
                cornerRadiusRatio: 1,
                useCornerRadiusAsFactor: true,
                padding: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
            )
        )
        finishTag.isHidden = !finished
        initialLayout(finished: finished)
    }

    private var titleLabel = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG1
        label.text = "게시글 제목"
    }

    private var tagLabel = BadgeLabel().then { label in
        let style = BadgeLabel.Style(
            font: .iosBody13R,
            backgroundColor: .clear,
            textColor: .primarydark,
            borderWidth: 0,
            borderColor: .primarydark,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        )

        label.applyStyle(style)
        label.text = "게시글 태그"
    }

    private var finishTag = UIView().then { view in
        view.backgroundColor = .darkG45
        view.clipsToBounds = true
        view.layer.cornerRadius = 4

        let label = UILabel()
        label.text = "모집 완료"
        label.font = .iosBody13B
        label.textColor = .darkG25

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(8)
            make.trailing.equalTo(view.snp.trailing).offset(-8)
            make.top.equalTo(view.snp.top).offset(5)
            make.bottom.equalTo(view.snp.bottom).offset(-5)
        }
    }

    private func setup() {
        addSubviews([
            titleLabel,
            tagLabel,
            finishTag,
        ])
    }

    private func initialLayout(finished: Bool) {
        tagLabel.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        finishTag.snp.removeConstraints()

        if finished {
            tagLabel.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top)
                make.leading.equalTo(self.snp.leading)
            }

            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(tagLabel.snp.bottom).offset(9)
                make.leading.equalTo(tagLabel.snp.leading)
                make.trailing.lessThanOrEqualTo(self.snp.trailing)
            }

            finishTag.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(12)
                make.leading.equalTo(tagLabel.snp.leading)
                make.bottom.equalTo(self.snp.bottom).offset(-3)
            }
        } else {
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
}
