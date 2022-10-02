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
                make.centerX.equalTo(navContentView.snp.centerX)
                make.bottom.equalTo(navContentView.snp.bottom).offset(-titleSpacing)
            }
        }
    }

    // MARK: Internal

    var topNotchView = UIView()
    var navContentView = UIView()
    var leftBtnItem = UIButton()
    var rightBtnItem = UIButton()
    var rightSecondBtnItem = UIButton()
    var titleLabel = UILabel().then { label in
        label.text = ""
        label.font = .iosBody17Sb
    }
}

// MARK: - Layout

extension RunnerbeNavBar {
    private func setupViews() {
        addSubviews([
            topNotchView,
            navContentView,
        ])

        navContentView.addSubviews([
            leftBtnItem,
            rightBtnItem,
            rightSecondBtnItem,
            titleLabel,
        ])
    }

    private func initialLayout() {
        topNotchView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top).offset(11)
            make.height.equalTo(AppContext.shared.safeAreaInsets.top)
        }

        navContentView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(topNotchView.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(AppContext.shared.navHeight)
        }

        leftBtnItem.snp.makeConstraints { make in
            make.leading.equalTo(navContentView.snp.leading).offset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        rightBtnItem.snp.makeConstraints { make in
            make.trailing.equalTo(navContentView.snp.trailing).offset(-16)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        rightSecondBtnItem.snp.makeConstraints { make in
            make.trailing.equalTo(rightBtnItem.snp.leading).offset(-12)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(navContentView.snp.centerX)
            make.bottom.equalTo(navContentView.snp.bottom).offset(-titleSpacing)
            make.top.equalTo(navContentView.snp.top).offset(8)
        }
    }
}
