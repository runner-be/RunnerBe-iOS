//
//  UserInfoWithSingleDivider.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import UIKit

final class UserInfoWithSingleDivider: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    func setup(userInfo: PostDetailUserConfig) {
        // TODO: avartarView
        userInfoView.setup(userInfo: userInfo)
    }

    private var userInfoView = UserInfoView()

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG5
    }

    private func setup() {
        addSubviews([
            userInfoView,
            hDivider,
        ])
    }

    private func initialLayout() {
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(20)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(1)
        }
    }
}
