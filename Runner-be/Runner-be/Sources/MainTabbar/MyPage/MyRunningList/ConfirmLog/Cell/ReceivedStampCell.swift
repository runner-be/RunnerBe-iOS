//
//  ReceivedStampCell.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

final class ReceivedStampCell: UICollectionViewCell {
    static let id = "\(ReceivedStampCell.self)"

    // MARK: - UI

    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 20
    }

    private let stampIconView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.darkG3.cgColor
        $0.backgroundColor = .darkG45
    }

    private let userNameLabel = UILabel().then {
        $0.text = "UserName"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular12
    }

    // MARK: - Init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    // MARK: - Methods

    func configure(receivedStamp: ReceivedStamp) {
        profileImageView.kf.setImage(
            with: URL(string: receivedStamp.userProfileURL),
            placeholder: Asset.iconsProfile48.uiImage
        )

        stampIconView.image = receivedStamp.stampStatus.icon
        userNameLabel.text = receivedStamp.userName
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension ReceivedStampCell {
    private func setup() {
        contentView.addSubviews([
            profileImageView,
            stampIconView,
            userNameLabel,
        ])
    }

    private func initialLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.size.equalTo(48)
        }

        stampIconView.snp.makeConstraints {
            $0.bottom.right.equalTo(profileImageView)
            $0.size.equalTo(20)
        }

        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}

extension ReceivedStampCell {
    static let size: CGSize = .init(
        width: 48,
        height: 68 // FIXME: magic number
    )
}
