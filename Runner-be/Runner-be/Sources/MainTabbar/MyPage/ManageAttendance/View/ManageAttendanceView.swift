//
//  ManageAttendanceView.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/07.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class MangeAttendanceView: UIView {
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
        badgeLabel.label.text = config.diligence

        // TODO: PROFILE
        if let url = config.profileURL,
           let profileURL = URL(string: url)
        {
            avatarView.kf.setImage(with: profileURL)
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
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
    }

    var writerIcon = UIImageView().then { view in
        view.image = Asset.iconsWriter24.uiImage

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

    var writerBadge = UIImageView().then { view in
        view.image = Asset.iconsWriter24.image
        view.isHidden = true
    }

    func setupViews() {
        addSubviews([
            avatarView,
            writerIcon,
            nickNameLabel,
            genderLabel,
            dot,
            ageLabel,
            badgeLabel,
            jobLabel,
            writerBadge,
        ])
    }

    func initialLayout() {
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.top).offset(2)
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
        }

        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nickNameLabel.snp.trailing).offset(8)
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
