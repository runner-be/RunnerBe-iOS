//
//  RunnerBeNavigationBar.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

final class RunnerbeNavBar: UIView {
    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var titleSpacing: CGFloat = 12 {
        didSet {
            titleLabel.snp.updateConstraints { make in
                make.centerX.equalTo(self.snp.centerX)
                make.bottom.equalTo(self.snp.bottom).offset(-titleSpacing)
            }
        }
    }

    // MARK: Internal

    var leftBtnItem = UIButton()
    var rightBtnItem = UIButton()
    var rightSecondBtnItem = UIButton()
    var titleLabel = UILabel()
}

// MARK: - Layout

extension RunnerbeNavBar {
    private func setupViews() {
        addSubviews([
            leftBtnItem,
            rightBtnItem,
            rightSecondBtnItem,
            titleLabel,
        ])
    }

    private func initialLayout() {
        leftBtnItem.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        }

        rightBtnItem.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        }

        rightSecondBtnItem.snp.makeConstraints { make in
            make.trailing.equalTo(rightBtnItem.snp.leading).offset(-12)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-titleSpacing)
        }

        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
}
