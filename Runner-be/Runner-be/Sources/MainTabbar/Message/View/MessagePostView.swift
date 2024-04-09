//
//  MessagePostView.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/13.
//

import SnapKit
import Then
import UIKit

final class MessagePostView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    var runningPaceBadge = RunningPaceView()

    var postTitle = UILabel().then { view in
        view.textColor = .darkG25
        view.font = .pretendardRegular14
    }

    private var rightArrow = UIImageView().then { view in
        view.image = UIImage(named: "Chevron_right_Xs")
    }

    private func setup() {
        backgroundColor = .darkG6
        addSubviews([
            runningPaceBadge,
            postTitle,
            rightArrow,
        ])
    }

    private func initialLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        runningPaceBadge.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(13)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-13)
            make.width.equalTo(69)
        }

        postTitle.snp.makeConstraints { make in
            make.centerY.equalTo(runningPaceBadge.snp.centerY)
            make.leading.equalTo(runningPaceBadge.snp.trailing).offset(8)
        }

        rightArrow.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(postTitle.snp.trailing).offset(2)
            make.trailing.equalTo(self.snp.trailing).offset(-18)
            make.width.height.equalTo(22)
        }
    }
}
