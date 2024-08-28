//
//  MyLogStampCell.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import UIKit

final class MyLogStampCell: UICollectionViewCell {
    static let id = "\(MyLogStampCell.self)"

    // MARK: - Properties

    // MARK: - UI

    private let stampIcon = UIImageView().then {
        $0.image = Asset.iconLogEmpty30.uiImage
    }

    private let futureDayLabel = UILabel().then {
        $0.text = "00"
        $0.textColor = .darkG5
        $0.font = .pretendardSemiBold16
        $0.isHidden = true
    }

    private let dayLabel = UILabel().then {
        $0.text = "00"
        $0.textColor = .darkG5
        $0.font = .pretendardSemiBold14
    }

    // MARK: - Init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        dayOfWeek _: String,
        date: Int
    ) {
        dayLabel.text = "\(date)"
    }
}

// MARK: - Layout

extension MyLogStampCell {
    private func setup() {
        contentView.addSubviews([
            stampIcon,
            futureDayLabel,
            dayLabel,
        ])
    }

    private func initialLayout() {
        stampIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(30)
        }

        futureDayLabel.snp.makeConstraints {
            $0.center.equalTo(stampIcon)
        }

        dayLabel.snp.makeConstraints {
            $0.top.equalTo(stampIcon.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
}

extension MyLogStampCell {
    static let size: CGSize = .init(
        width: (UIScreen.main.bounds.width - 32) / 7,
        height: 56 // FIXME: magic number
    )
}
