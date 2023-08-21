//
//  MyInfoView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class MyInfoView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        reset()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with config: UserConfig) {
        nickNameLabel.text = config.nickName
        genderLabel.text = config.gender
        ageLabel.text = config.age
        jobLabel.text = config.job

        switch config.diligence {
        case "성실 러너":
            badgeLabel.iconView.image = Asset.smile.uiImage
        case "노력 러너":
            badgeLabel.iconView.image = Asset.icEffortRunner.uiImage
        case "불량 러너":
            badgeLabel.iconView.image = Asset.icBadRunner.uiImage
        case "초보 러너":
            badgeLabel.iconView.image = Asset.icBasicRunner.uiImage
        default:
            break
        }

        badgeLabel.label.text = config.diligence
        // TODO: PROFILE
        if let url = config.profileURL,
           !url.isEmpty,
           let profileURL = URL(string: url)
        {
            avatarView.kf.setImage(with: profileURL)
        } else {
            avatarView.image = Asset.profileEmptyIcon.uiImage
        }
    }

    func reset() {
        avatarView.image = Asset.profileEmptyIcon.uiImage
        nickNameLabel.text = "NickName"
        genderLabel.text = "gender"
        ageLabel.text = "00대 ~"
        badgeLabel.label.text = "JOB"
        badgeLabel.label.text = "~러너"
    }

    var avatarView = UIImageView().then { view in
        view.image = Asset.profileEmptyIcon.uiImage

        view.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(88)
        }
        view.layer.cornerRadius = 39
        view.clipsToBounds = true
    }

    var cameraIcon = UIImageView().then { view in
        view.image = Asset.camera.uiImage

        view.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
    }

    var nickNameLabel = UILabel().then { label in
        label.font = .iosTitle21Sb
        label.textColor = .darkG1
        label.text = "NICKNAME"
    }

    var genderLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG35
        label.text = "성별"
    }

    var dot = UIView().then { view in
        view.backgroundColor = .darkG35
        view.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(2)
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 1
    }

    var ageLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG35
        label.text = "00대 후반"
    }

    var badgeLabel = RunnerBadge()

    var jobLabel = BadgeLabel().then { label in
        let style = BadgeLabel.Style(
            font: .iosCaption11R,
            backgroundColor: .darkG5,
            textColor: .primary,
            borderWidth: 0,
            borderColor: .clear,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6)
        )

        label.applyStyle(style)
        label.text = "JOB/JOB"
    }

    func setupViews() {
        addSubviews([
            avatarView,
            cameraIcon,
            nickNameLabel,
            genderLabel,
            dot,
            ageLabel,
            badgeLabel,
            jobLabel,
        ])
    }

    func initialLayout() {
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }

        cameraIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.avatarView.snp.bottom)
            make.trailing.equalTo(self.avatarView.snp.trailing).offset(8)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.top).offset(2)
            make.leading.equalTo(avatarView.snp.trailing).offset(18)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
        }

        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nickNameLabel.snp.leading)
        }

        dot.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.leading.equalTo(genderLabel.snp.trailing).offset(4)
        }

        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.leading.equalTo(dot.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
        }

        badgeLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(12)
            make.leading.equalTo(genderLabel.snp.leading)
        }

        jobLabel.snp.makeConstraints { make in
            make.centerY.equalTo(badgeLabel.snp.centerY)
            make.leading.equalTo(badgeLabel.snp.trailing).offset(8)
        }
    }
}
