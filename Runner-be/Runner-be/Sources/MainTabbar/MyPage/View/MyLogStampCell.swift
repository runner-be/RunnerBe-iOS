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

    // 사용하는 CollectionView에서 현재 Cell의 날짜를 구분하가위해 사용됨
    var date: Date?

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
        $0.layer.cornerRadius = 10
        $0.textAlignment = .center
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
        with logStamp: LogStamp,
        isMyLogStamp: Bool = true
    ) {
        date = logStamp.date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")

        formatter.dateFormat = "dd"
        var formattedCurrentDate = formatter.string(from: currentDate)
        var formattedLogDate = formatter.string(from: logStamp.date)
        dayLabel.text = formattedLogDate
        futureDayLabel.text = formattedLogDate

        formatter.dateFormat = "yyyy-MM-dd"
        formattedCurrentDate = formatter.string(from: currentDate)
        formattedLogDate = formatter.string(from: logStamp.date)
        let isToday = formattedCurrentDate == formattedLogDate
        dayLabel.layer.backgroundColor = isToday ? UIColor.darkG6.cgColor : UIColor.clear.cgColor
        dayLabel.textColor = isToday ? .darkG2 : .darkG5

        let isFuture = currentDate.timeIntervalSince1970 < logStamp.date.timeIntervalSince1970

        futureDayLabel.isHidden = !isFuture
        stampIcon.isHidden = isFuture
        dayLabel.isHidden = isFuture

        if let stampIcon = logStamp.stampType?.icon {
            self.stampIcon.image = stampIcon
        } else if logStamp.isGathering {
            stampIcon.image = isMyLogStamp ? Asset.iconLogPostable30.uiImage : Asset.iconOthersLogPostable30.uiImage
        } else {
            stampIcon.image = isMyLogStamp ? Asset.iconLogEmpty30.uiImage :
                Asset.iconOthersLogEmpty30.uiImage
        }
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
            $0.center.equalToSuperview()
        }

        dayLabel.snp.makeConstraints {
            $0.top.equalTo(stampIcon.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
}

extension MyLogStampCell {
    static let size: CGSize = .init(
        width: (UIScreen.main.bounds.width - 32) / 7,
        height: 56 // FIXME: magic number
    )
}
