//
//  BasicPostInfoView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import KakaoSDKCommon
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BasicPostInfoView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    func configure(with item: PostCellConfig, backgroundColor: UIColor = .darkG55) {
        bookMarkIcon.isSelected = item.bookmarked
        titleLabel.text = item.title
        dateLabel.label.text = item.date
        participantLabel.label.text = "\(item.gender) · \(item.ageText)"
        bookMarkIcon.isSelected = item.bookmarked
        timeLabel.label.text = item.time

        let numProfiles = CGFloat(item.attendanceProfiles.count)
        let profileSpacing = Constants.Profile.spacing
        let profileDimension = Constants.Profile.dimension
        var offsetLeading = (numProfiles - 1) * profileDimension + profileSpacing * (numProfiles - 1)
        for profile in item.attendanceProfiles {
            let imageView = UIImageView()
            profileFrameView.addSubview(imageView)

            if let profileURL = profile.profileImageURL {
                imageView.kf.setImage(with: URL(string: profileURL), placeholder: Asset.profileEmptyIcon.uiImage)
            } else {
                imageView.image = Asset.profileEmptyIcon.uiImage
            }

            imageView.snp.makeConstraints { make in
                make.top.equalTo(profileFrameView.snp.top)
                make.bottom.equalTo(profileFrameView.snp.bottom)
                make.leading.equalTo(profileFrameView.snp.leading).offset(offsetLeading)
                make.width.equalTo(profileDimension)
                make.height.equalTo(profileDimension)
            }

            imageView.layer.borderColor = backgroundColor.cgColor
            imageView.layer.borderWidth = Constants.Profile.borderWidth
            imageView.layer.cornerRadius = Constants.Profile.cornerRadius

            offsetLeading -= profileDimension + profileSpacing
        }
        profileFrameView.snp.updateConstraints { make in
            make.width.equalTo(numProfiles * profileDimension + profileSpacing * (numProfiles - 1))
        }
    }

    func reset() {
        bookMarkIcon.isSelected = false
        profileFrameView.subviews.forEach { $0.removeFromSuperview() }
    }

    enum Constants {
        enum BookMark {}

        enum Title {
            static let height: CGFloat = 25
            static let font: UIFont = .iosTitle19R
            static let textColor: UIColor = .darkG2
        }

        enum Profile {
            static let top: CGFloat = 14

            static let dimension: CGFloat = 28
            static let spacing: CGFloat = -8
            static let borderWidth: CGFloat = 2
            static let cornerRadius: CGFloat = dimension / 2.0
        }

        enum InfoLabel {
            static let size: CGSize = .init(width: 20, height: 20)
            static let spacing: CGFloat = 8

            static let font: UIFont = .iosBody13R
            static let textColor: UIColor = .darkG2

            enum Date {
                static let top: CGFloat = 16
            }

            enum Participant {
                static let leading: CGFloat = 40
            }

            enum Time {
                static let top: CGFloat = 4
            }
        }
    }

    var blurAlpha: CGFloat = 0.7

    var bookMarkIcon = UIButton().then { button in
        button.setImage(Asset.bookmarkTabIconNormal.uiImage, for: .normal)
        button.setImage(Asset.bookmarkTabIconFocused.uiImage, for: .selected)
    }

    var titleLabel = UILabel().then { label in
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = "PostTitlePlaceHolder"
    }

    var profileFrameView = UIView()

    var dateLabel = IconLabel(iconSize: Constants.InfoLabel.size, spacing: Constants.InfoLabel.spacing).then { view in
        view.label.font = Constants.InfoLabel.font
        view.label.textColor = Constants.InfoLabel.textColor
        view.label.text = "3/31 (금) AM 6:00"
        view.icon.image = Asset.scheduled.uiImage
    }

    var timeLabel = IconLabel(iconSize: Constants.InfoLabel.size, spacing: Constants.InfoLabel.spacing).then { view in
        view.label.font = Constants.InfoLabel.font
        view.label.textColor = Constants.InfoLabel.textColor
        view.label.text = "2시간 20분"
        view.icon.image = Asset.time.uiImage
    }

    var participantLabel = IconLabel(iconSize: Constants.InfoLabel.size, spacing: Constants.InfoLabel.spacing).then { view in
        view.label.font = Constants.InfoLabel.font
        view.label.textColor = Constants.InfoLabel.textColor
        view.label.text = "여성 · 20-35"
        view.icon.image = Asset.group.uiImage
    }
}

extension BasicPostInfoView {
    private func setup() {
        backgroundColor = .clear
        addSubviews([
            bookMarkIcon,
            profileFrameView,
            titleLabel,
            dateLabel,
            timeLabel,
            participantLabel,
        ])
    }

    private func initialLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(Constants.Title.height)
        }

        bookMarkIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalTo(self.snp.trailing)
        }

        profileFrameView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.Profile.top)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(0) // update dynamically
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileFrameView.snp.bottom).offset(Constants.InfoLabel.Date.top)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        participantLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(Constants.InfoLabel.Participant.leading)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
            make.top.equalTo(dateLabel.snp.top)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.InfoLabel.Time.top)
            make.leading.equalTo(titleLabel.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}

extension BasicPostInfoView {
    static var height: CGFloat {
        return Constants.Title.height
            + Constants.Profile.top
            + Constants.Profile.dimension
            + Constants.InfoLabel.Date.top
            + Constants.InfoLabel.size.height
            + Constants.InfoLabel.Time.top
            + Constants.InfoLabel.size.height
    }
}
