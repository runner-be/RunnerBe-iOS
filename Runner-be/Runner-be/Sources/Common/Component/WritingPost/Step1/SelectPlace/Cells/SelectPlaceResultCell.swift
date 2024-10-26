//
//  SelectPlaceResultCell.swift
//  Runner-be
//
//  Created by 김창규 on 8/22/24.
//

import Then
import UIKit

final class SelectPlaceResultCell: UICollectionViewCell {
    static let id = "\(SelectPlaceResultCell.self)"

    // MARK: - UI

    private let locationInfoLabel = UILabel().then {
        $0.text = "Title"
        $0.font = .pretendardSemiBold16
        $0.textColor = .darkG2
    }

    private let placeNameLabel = UILabel().then {
        $0.text = "Sub Title"
        $0.font = .pretendardRegular14
        $0.textColor = .darkG35
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

    // MARK: - Methods

    func configure(
        placeName: String,
        placeAddress: String
    ) {
        locationInfoLabel.text = placeName
        placeNameLabel.text = placeAddress
    }
}

// MARK: - Layout

extension SelectPlaceResultCell {
    private func setup() {
        contentView.addSubviews([
            locationInfoLabel,
            placeNameLabel,
        ])
    }

    private func initialLayout() {
        locationInfoLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(19)
        }

        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(locationInfoLabel.snp.bottom).offset(4)
            $0.left.equalTo(locationInfoLabel)
        }
    }
}

extension SelectPlaceResultCell {
    static let size: CGSize = .init(
        width: UIScreen.main.bounds.width,
        height: 86 // FIXME: magic number
    )
}
