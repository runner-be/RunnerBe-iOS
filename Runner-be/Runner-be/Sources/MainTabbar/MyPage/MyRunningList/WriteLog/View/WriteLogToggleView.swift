//
//  WriteLogToggleView.swift
//  Runner-be
//
//  Created by 김창규 on 8/31/24.
//

import UIKit

final class WriteLogToggleView: UIView {
    // MARK: - Properties

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.text = "공개 설정"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let subTitleLabel = UILabel().then {
        $0.text = "이 글을 모두가 볼 수 있습니다."
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    var toggleButton = ToggleSwitch()

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
}

// MARK: - Layout

extension WriteLogToggleView {
    private func setupViews() {
        addSubviews([
            titleLabel,
            subTitleLabel,
            toggleButton,
        ])
    }

    private func initialLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(8)
            $0.top.bottom.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }

        toggleButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(38)
            $0.height.equalTo(24)
        }
    }
}
