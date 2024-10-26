//
//  MyProfileView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Kingfisher
import SnapKit
import Then
import UIKit

final class MyProfileView: UIView {
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

        if let url = config.profileURL,
           !url.isEmpty,
           let profileURL = URL(string: url)
        {
            avatarView.kf.setImage(with: profileURL)
        } else {
            avatarView.image = Asset.profileEmptyIcon.uiImage
        }

        myInfoView.configure(userConfig: config)

        BasicUserKeyChainService.shared.nickName = config.nickName
    }

    func reset() {
        avatarView.image = Asset.profileEmptyIcon.uiImage
        nickNameLabel.text = "NickName"
        genderLabel.text = "gender"
        ageLabel.text = "00대 ~"
    }

    var avatarView = UIImageView().then { view in
        view.image = Asset.profileEmptyIcon.uiImage

        view.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(72)
        }
        view.layer.cornerRadius = 36
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
        label.font = .pretendardSemiBold16
        label.textColor = .darkG1
        label.text = "NICKNAME"
    }

    var genderLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG1
        label.text = "성별"
    }

    var dot = UIView().then { view in
        view.backgroundColor = .darkG1
        view.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(2)
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 1
    }

    var ageLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG1
        label.text = "00대 후반"
    }

    var jobLabel = BadgeLabel().then { label in
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

    var editProfileLabel = UILabel().then { label in
        label.font = .pretendardRegular12
        label.text = "프로필 수정하기"
        label.textColor = .darkG2
    }

    var myInfoView = MyInfoView()
}

extension MyProfileView {
    func setupViews() {
        addSubviews([
            avatarView,
            cameraIcon,
            nickNameLabel,
            genderLabel,
            dot,
            ageLabel,
            jobLabel,
            editProfileLabel,
            myInfoView,
        ])
    }

    func initialLayout() {
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(24)
            make.leading.equalTo(self.snp.leading)
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

        jobLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ageLabel.snp.centerY)
            make.leading.equalTo(ageLabel.snp.trailing).offset(8)
        }

        editProfileLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.leading.equalTo(genderLabel.snp.leading)
        }

        myInfoView.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(28)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
