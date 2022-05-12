//
//  BasicPostInfoView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

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

    func configure(with item: PostCellConfig) {
        bookMarkIcon.isSelected = item.bookmarked
        titleLabel.text = item.title
        dateLabel.label.text = item.date
        participantLabel.label.text = "\(item.gender) · \(item.ageText)"
        bookMarkIcon.isSelected = item.bookmarked
        timeLabel.label.text = item.time

        let numProfiles = CGFloat(item.attendanceProfiles.count)
        let profileSpacing: CGFloat = -8
        let profileDimension: CGFloat = 28
        var offsetLeading = (numProfiles - 1) * profileDimension + profileSpacing * (numProfiles - 1)
        for (idx, profile) in item.attendanceProfiles.enumerated() {
            let imageView = UIImageView()
            participantFrameView.addSubview(imageView)

            if let profileURL = profile.profileImageURL {
                imageView.kf.setImage(with: URL(string: profileURL), placeholder: Asset.profileEmptyIcon.uiImage)
            } else {
                imageView.image = Asset.profileEmptyIcon.uiImage
            }

            imageView.snp.makeConstraints { make in
                make.top.equalTo(participantFrameView.snp.top)
                make.bottom.equalTo(participantFrameView.snp.bottom)
                make.leading.equalTo(participantFrameView.snp.leading).offset(offsetLeading)
                make.width.equalTo(profileDimension)
                make.height.equalTo(profileDimension)
            }

            imageView.layer.borderColor = UIColor.darkG55.cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.cornerRadius = profileDimension / 2.0

            offsetLeading -= profileDimension + profileSpacing
        }
        participantFrameView.snp.updateConstraints { make in
            make.width.equalTo(numProfiles * profileDimension + profileSpacing * (numProfiles - 1))
        }
    }

    func reset() {
        bookMarkIcon.isSelected = false
        participantFrameView.subviews.forEach { $0.removeFromSuperview() }
    }

    var blurAlpha: CGFloat = 0.7

    var bookMarkIcon = UIButton().then { button in
        button.setImage(Asset.bookmarkTabIconNormal.uiImage, for: .normal)
        button.setImage(Asset.bookmarkTabIconFocused.uiImage, for: .selected)
    }

    var titleLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG2
        label.text = "PostTitlePlaceHolder"
    }

    var participantFrameView = UIView()

    var dateLabel = IconLabel(iconSize: CGSize(width: 20, height: 20), spacing: 8).then { view in
        view.label.font = .iosBody13R
        view.label.textColor = .darkG2
        view.label.text = "3/31 (금) AM 6:00"
        view.icon.image = Asset.scheduled.uiImage
    }

    var timeLabel = IconLabel(iconSize: CGSize(width: 20, height: 20), spacing: 8).then { view in
        view.icon.image = Asset.time.uiImage
        view.label.font = .iosBody13R
        view.label.textColor = .darkG2
        view.label.text = "2시간 20분"
    }

    var participantLabel = IconLabel(iconSize: CGSize(width: 20, height: 20), spacing: 8).then { view in
        view.label.font = .iosBody13R
        view.label.textColor = .darkG2
        view.label.text = "여성 · 20-35"
        view.icon.image = Asset.group.uiImage
    }
}

extension BasicPostInfoView {
    private func setup() {
        backgroundColor = .clear
        addSubviews([
            bookMarkIcon,
            participantFrameView,
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
        }

        bookMarkIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalTo(self.snp.trailing)
        }

        participantFrameView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(0)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(participantFrameView.snp.bottom).offset(16)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        participantLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(40)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
            make.top.equalTo(dateLabel.snp.top)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}

extension BasicPostInfoView {
    static var height: CGFloat {
        return 25 + 81 + 20
    }
}
