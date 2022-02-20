//
//  BasicPostCellView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/20.
//

import SnapKit
import Then
import UIKit

class BasicPostCellView: UICollectionViewCell {
    enum PostState {
        case open
        case closed
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    override func prepareForReuse() {
        postState = .open
    }

    var postState: PostState = .closed {
        didSet {
            updateCover()
        }
    }

    var blurAlpha: CGFloat = 1

    var profileLabel = IconLabel().then { view in
        view.icon.image = Asset.profileEmptyIcon.uiImage
        view.iconSize = CGSize(width: 14, height: 14)
        view.label.font = .iosCaption11R
        view.label.textColor = .darkG35
        view.spacing = 6
        view.padding = UIEdgeInsets(top: 3, left: 1, bottom: 3, right: 0)
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

    var dateLabel = IconLabel().then { view in
        view.icon.image = Asset.scheduled.uiImage
        view.iconSize = CGSize(width: 19, height: 19)
        view.label.font = .iosBody13R
        view.label.textColor = .darkG2
        view.label.text = "3/31 (금) AM 6:00"
        view.spacing = 8
    }

    var participantLabel = IconLabel().then { view in
        view.icon.image = Asset.group.uiImage
        view.iconSize = CGSize(width: 19, height: 19)
        view.label.font = .iosBody13R
        view.label.textColor = .darkG2
        view.label.text = "여성 · 20-35"
        view.spacing = 8
    }

    var placeLabel = IconLabel().then { view in
        view.icon.image = Asset.place.uiImage
        view.iconSize = CGSize(width: 19, height: 19)
        view.label.font = .iosBody13R
        view.label.textColor = .darkG2
        view.label.text = "동작구 사당1동"
        view.spacing = 8
    }

    private var cover: UIView?

    private func updateCover() {
        cover?.removeFromSuperview()
        if postState == .open {
            cover = nil
            return
        }

        let cover = UIView()
        addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }

        switch postState {
        case .closed:
            let coverLabel = UILabel()
            coverLabel.font = .iosBody15R
            coverLabel.textColor = .darkG35
            coverLabel.text = L10n.Home.PostList.Cell.Cover.closed

            let blur = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.alpha = blurAlpha
            blurView.frame = cover.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cover.addSubview(blurView)

            cover.addSubview(coverLabel)
            coverLabel.snp.makeConstraints { make in
                make.centerX.equalTo(cover.snp.centerX)
                make.centerY.equalTo(cover.snp.centerY)
            }
        case .open:
            break
        }

        self.cover = cover
    }
}

extension BasicPostCellView {
    private func setup() {
        backgroundColor = .darkG55
        addSubviews([
            profileLabel,
            bookMarkIcon,
            titleLabel,
            dateLabel,
            participantLabel,
            placeLabel,
        ])

        updateCover()
    }

    private func initialLayout() {
        layer.cornerRadius = 12
        clipsToBounds = true

        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(17)
        }

        bookMarkIcon.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileLabel.snp.leading)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(profileLabel.snp.leading)
        }

        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(27)
            make.top.equalTo(dateLabel.snp.top)
        }

        participantLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileLabel.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom).offset(-24)
        }
    }
}

extension BasicPostCellView {
    static let id: String = "\(BasicPostCellView.self)"
}
