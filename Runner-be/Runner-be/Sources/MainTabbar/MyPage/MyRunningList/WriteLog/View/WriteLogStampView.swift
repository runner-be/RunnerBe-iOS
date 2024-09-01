//
//  WriteLogStampView.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import UIKit
enum LogStampType {}

final class WriteLogStampView: UIView {
    // MARK: - Properties

    // MARK: - UI

    private let stampIcon = UIImageView().then {
        $0.image = Asset.iconLogEmpty30.uiImage
    }

    private let stampLabel = UILabel().then {
        $0.text = "터치해서 러닝 스탬프를 찍어볼까요?"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular18
        $0.textAlignment = .center
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func update(logStamp: LogStamp2) {
        stampIcon.image = logStamp.status?.icon
        stampLabel.text = logStamp.status?.title
    }
}

// MARK: - Layout

extension WriteLogStampView {
    private func setupViews() {
        addSubviews([
            stampIcon,
            stampLabel,
        ])
    }

    private func initialLayout() {
        stampIcon.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(64)
        }

        stampLabel.snp.makeConstraints {
            $0.top.equalTo(stampIcon.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
    }
}
