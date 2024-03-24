//
//  UserInfoView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Kingfisher
import SnapKit
import Then
import UIKit

final class UserInfoView: UIView {
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

        switch userInfo.diligence {
        case "성실 출석":
            badgeLabel.iconView.image = Asset.smile.uiImage
        case "노력 출석":
            badgeLabel.iconView.image = Asset.icEffortRunner.uiImage
        case "불량 출석":
            badgeLabel.iconView.image = Asset.icBadRunner.uiImage
        case "초보 출석":
            badgeLabel.iconView.image = Asset.icBasicRunner.uiImage
        default:
            break
        }

        if let pace = userInfo.pace {
            runningPaceLabel.configure(pace: pace, viewType: .userInfo)
        }

        if let url = userInfo.profileURL,
           let profileURL = URL(string: url)
        {
            avatarView.kf.setImage(with: profileURL)
        }
    }

    func reset() {
        avatarView.image = Asset.profileEmptyIcon.uiImage
    }

    var avatarView = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        view.layer.cornerRadius = 24
        view.clipsToBounds = true

        view.image = Asset.profileEmptyIcon.uiImage
    }

    var nameLabel = UILabel().then { label in
        label.font = .pretendardSemiBold14
        label.textColor = .darkG1
        label.text = ""
    }

    var genderLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG35
        label.text = ""
    }

    private var dotSeparator = UIView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(2)
        }

        view.backgroundColor = .darkG35
        view.clipsToBounds = true
        view.layer.cornerRadius = 1
    }

    var ageLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG35
        label.text = ""
    }

    private lazy var genderDotAgeStack = UIStackView.make(
        with: [genderLabel, dotSeparator, ageLabel],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 4
    )

    var ownerMark = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        view.image = Asset.postOwner.uiImage
    }

    var runningPaceLabel = RunningPaceView()

    var badgeLabel = RunnerBadge()

    var jobTagLabel = BadgeLabel().then { label in
        let style = BadgeLabel.Style(
            font: .pretendardRegular10,
            backgroundColor: .darkG5,
            textColor: .darkG3,
            borderWidth: 0,
            borderColor: .clear,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6)
        )

        label.applyStyle(style)
        label.text = "JOB/JOB"
    }

    private func setup() {
        addSubviews([
            avatarView,
            nameLabel,
            genderDotAgeStack,
            ownerMark,
            runningPaceLabel,
            badgeLabel,
            jobTagLabel,
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

        runningPaceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(18)
            make.bottom.equalTo(self.snp.bottom)
        }

        badgeLabel.snp.makeConstraints { make in
            make.leading.equalTo(runningPaceLabel.snp.trailing).offset(8)
            make.centerY.equalTo(runningPaceLabel.snp.centerY)
            make.height.equalTo(18)
        }

        jobTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(badgeLabel.snp.trailing).offset(8)
            make.centerY.equalTo(badgeLabel.snp.centerY)
            make.height.equalTo(18)
        }

        ownerMark.snp.makeConstraints { make in
            make.centerY.equalTo(genderDotAgeStack.snp.centerY)
            make.leading.equalTo(genderDotAgeStack.snp.trailing).offset(8)
        }
    }
}
