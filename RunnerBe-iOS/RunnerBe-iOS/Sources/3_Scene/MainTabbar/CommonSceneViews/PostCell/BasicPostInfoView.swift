//
//  BasicPostInfoView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

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
        profileLabel.label.text = item.writerName
        bookMarkIcon.isSelected = item.bookmarked
        titleLabel.text = item.title
        dateLabel.label.text = item.date
        participantLabel.label.text = "\(item.gender) · \(item.ageText)"
        placeLabel.label.text = item.place
        bookMarkIcon.isSelected = item.bookmarked
        timeLabel.label.text = item.time
    }

    var blurAlpha: CGFloat = 0.7

    var profileLabel = IconLabel().then { view in
        view.label.font = .iosCaption11R
        view.label.textColor = .darkG35
        view.spacing = 6
        view.icon.image = Asset.profileEmptyIcon.uiImage
        view.iconSize = CGSize(width: 14, height: 14)
        view.label.text = "러너1234"
    }

    var bookMarkIcon = UIButton().then { button in
        button.setImage(Asset.bookmarkTabIconNormal.uiImage, for: .normal)
        button.setImage(Asset.bookmarkTabIconFocused.uiImage, for: .selected)
    }

    var titleLabel = UILabel().then { label in
        label.font = .iosBody17R
        label.textColor = .darkG2
        label.text = "PostTitlePlaceHolder"
    }

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

    var placeLabel = IconLabel(iconSize: CGSize(width: 20, height: 20), spacing: 8).then { view in
        view.label.font = .iosBody13R
        view.label.textColor = .darkG2
        view.label.text = "동작구 사당1동"
        view.icon.image = Asset.place.uiImage
    }
}

extension BasicPostInfoView {
    private func setup() {
        backgroundColor = .clear
        addSubviews([
            profileLabel,
            bookMarkIcon,
            titleLabel,
            dateLabel,
            timeLabel,
            participantLabel,
            placeLabel,
        ])
    }

    private func initialLayout() {
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        }

        bookMarkIcon.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.top)
            make.trailing.equalTo(self.snp.trailing)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileLabel.snp.leading)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(profileLabel.snp.leading)
        }

        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(27)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
            make.top.equalTo(dateLabel.snp.top)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileLabel.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }

        participantLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.top)
            make.leading.equalTo(placeLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
        }
    }
}
