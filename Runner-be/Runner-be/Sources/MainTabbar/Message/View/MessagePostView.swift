//
//  MessagePostView.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/13.
//

import SnapKit
import Then
import UIKit

class MessagePostView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    var badgeLabel = UIButton().then { view in
        view.sizeToFit()
        view.setTitleColor(.primarydark, for: .normal)
        view.titleLabel?.font = .iosBody13R
//        view.setTitle(L10n.MyPage.MyPost.Manage.SaveButton.title, for: .normal)
        view.layer.borderColor = UIColor.primarydark.cgColor
        view.titleLabel?.textAlignment = .center
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isEnabled = false
    }

    var postTitle = UILabel().then { view in
        view.textColor = .darkG25
        view.font = .iosBody17R
    }

    private var rightArrow = UIImageView().then { view in
        view.image = UIImage(named: "Chevron_right_Xs")
    }

    private func setup() {
        backgroundColor = .darkG6
        addSubviews([
            badgeLabel,
            postTitle,
            rightArrow,
        ])
    }

    private func initialLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        badgeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-18)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }

        postTitle.snp.makeConstraints { make in
            make.centerY.equalTo(badgeLabel)
            make.leading.equalTo(badgeLabel.snp.trailing).offset(12)
        }

        rightArrow.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
        }
    }
}
