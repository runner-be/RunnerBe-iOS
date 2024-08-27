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

    private let dayOfWeekLabel = UILabel().then {
        $0.text = "월"
        $0.textColor = .darkG45
        $0.font = .pretendardSemiBold16
        $0.contentMode = .center
    }

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
        dayOfWeek: String,
        date: Int
    ) {
        dayOfWeekLabel.text = dayOfWeek
        dayLabel.text = "\(date)"
    }
}

// MARK: - Layout

extension MyLogStampCell {
    private func setup() {
        contentView.addSubviews([
            dayOfWeekLabel,
            stampIcon,
            futureDayLabel,
            dayLabel,
        ])
    }

    private func initialLayout() {
        dayOfWeekLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
        }

        stampIcon.snp.makeConstraints {
            $0.top.equalTo(dayOfWeekLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(30)
        }

        futureDayLabel.snp.makeConstraints {
            $0.center.equalTo(stampIcon)
        }

        dayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(20)
        }
    }
}

extension MyLogStampCell {
    static let size: CGSize = .init(
        width: (UIScreen.main.bounds.width - 32) / 7,
        height: 102 // FIXME: magic number
    )
}
