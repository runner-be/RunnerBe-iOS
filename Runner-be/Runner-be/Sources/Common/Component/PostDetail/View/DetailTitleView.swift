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

    func configure(title: String, runningPace: String, isFinished: Bool) {
        titleLabel.text = title
        runningPaceView.configure(pace: runningPace, viewType: .postDetail)
        if isFinished {
            tagLabel.text = "모집 완료"
        } else {
            tagLabel.text = "모집중"
        }
    }

    private var tagLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .primary
        label.text = "게시글 태그"
    }

    private var titleLabel = UILabel().then { label in
        label.font = .pretendardSemiBold18
        label.textColor = .darkG1
        label.text = "게시글 제목"
    }

    private var runningPaceView = RunningPaceView()

    private func setup() {
        addSubviews([
            titleLabel,
            tagLabel,
            runningPaceView,
        ])
    }

    private func initialLayout() {
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(4)
            make.leading.equalTo(tagLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
        }

        runningPaceView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
