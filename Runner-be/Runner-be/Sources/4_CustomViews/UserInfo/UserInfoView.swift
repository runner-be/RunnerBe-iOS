//
//  UserInfoView.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class UserInfoView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    func setup(userInfo: UserConfig) {
        nameLabel.text = userInfo.nickName
        genderLabel.text = userInfo.gender
        ageLabel.text = userInfo.age
        ownerMark.isHidden = !userInfo.isPostOwner
        jobTagLabel.text = userInfo.job
        badgeLabel.label.text = userInfo.diligence

        if let url = userInfo.profileURL,
           let profileURL = URL(string: url)
        {
            avatarView.kf.setImage(with: profileURL)
        }
    }

    func reset() {
        avatarView.image = Asset.profileEmptyIcon.uiImage
    }

    private var avatarView = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        view.layer.cornerRadius = 24
        view.clipsToBounds = true

        view.image = Asset.profileEmptyIcon.uiImage
    }

    private var nameLabel = UILabel().then { label in
        label.font = .iosBody15B
        label.textColor = .darkG2
        label.text = "닉네임"
    }

    private var genderLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG25
        label.text = "여성"
    }

    private var dotSeparator = UIView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(2)
        }

        view.backgroundColor = .darkG25
        view.clipsToBounds = true
        view.layer.cornerRadius = 1
    }

    private var ageLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG25
        label.text = "20대 후반"
    }

    private lazy var genderDotAgeStack = UIStackView.make(
        with: [genderLabel, dotSeparator, ageLabel],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 4
    )

    private var ownerMark = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(16)
        }

        view.image = Asset.postOwner.uiImage
    }

    private var badgeLabel = IconBadgeLabel()

    private var jobTagLabel = BadgeLabel().then { label in
        let style = BadgeLabel.Style(
            font: .iosBody13R,
            backgroundColor: .darkG5,
            textColor: .primary,
            borderWidth: 0,
            borderColor: .primarydark,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        )

        label.applyStyle(style)
        label.text = "TAGTAG"
    }

//    private var hDivider = UIView().then { view in
//        view.backgroundColor = .darkG5
//    }

    private func setup() {
        addSubviews([
            avatarView,
            nameLabel,
            genderDotAgeStack,
            badgeLabel,
            jobTagLabel,
            ownerMark,
//            hDivider,
        ])
    }

    private func initialLayout() {
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.top)
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
        }

        genderDotAgeStack.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }

        badgeLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }

        jobTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(badgeLabel.snp.trailing).offset(8)
            make.centerY.equalTo(badgeLabel.snp.centerY)
        }

        ownerMark.snp.makeConstraints { make in
            make.centerY.equalTo(genderDotAgeStack.snp.centerY)
            make.leading.equalTo(genderDotAgeStack.snp.trailing).offset(8)
        }

//        hDivider.snp.makeConstraints { make in
//            make.top.equalTo(avatarView.snp.bottom).offset(20)
//            make.leading.equalTo(self.snp.leading)
//            make.trailing.equalTo(self.snp.trailing)
//            make.bottom.equalTo(self.snp.bottom)
//            make.height.equalTo(1)
//        }
    }
}
