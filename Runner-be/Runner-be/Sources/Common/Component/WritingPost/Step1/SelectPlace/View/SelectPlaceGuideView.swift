//
//  SelectPlaceGuideView.swift
//  Runner-be
//
//  Created by 김창규 on 8/21/24.
//

import Then
import UIKit

final class SelectPlaceGuideView: UIView {
    // MARK: - UI

    private let mainTitle = UILabel().then {
        $0.text = "이렇게 검색해 보세요"
        $0.textColor = .darkG3
        $0.font = .pretendardSemiBold18
    }

    private let title1 = UILabel().then {
        $0.text = "도로명 + 건물번호"
        $0.textColor = .darkG3
        $0.font = .pretendardSemiBold18
    }

    private let description1 = UILabel().then {
        $0.text = "예) 러너비로 12길 3"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    private let title2 = UILabel().then {
        $0.text = "지역명 + 번지"
        $0.textColor = .darkG3
        $0.font = .pretendardSemiBold18
    }

    private let description2 = UILabel().then {
        $0.text = "러너비동 12-3"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    private let title3 = UILabel().then {
        $0.text = "건물명, 아파트명"
        $0.textColor = .darkG3
        $0.font = .pretendardSemiBold18
    }

    private let description3 = UILabel().then {
        $0.text = "러너비아파트 101동"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
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
}

// MARK: - Layout

extension SelectPlaceGuideView {
    private func setupViews() {
        addSubviews([
            mainTitle,
            title1,
            description1,
            title2,
            description2,
            title3,
            description3,
        ])
    }

    private func initialLayout() {
        mainTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(24)
        }

        title1.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(16)
            $0.left.equalTo(mainTitle)
        }

        description1.snp.makeConstraints {
            $0.top.equalTo(title1.snp.bottom).offset(4)
            $0.left.equalTo(title1)
        }

        title2.snp.makeConstraints {
            $0.top.equalTo(description1.snp.bottom).offset(12)
            $0.left.equalTo(mainTitle)
        }

        description2.snp.makeConstraints {
            $0.top.equalTo(title2.snp.bottom).offset(4)
            $0.left.equalTo(title2)
        }

        title3.snp.makeConstraints {
            $0.top.equalTo(description2.snp.bottom).offset(12)
            $0.left.equalTo(mainTitle)
        }

        description3.snp.makeConstraints {
            $0.top.equalTo(title3.snp.bottom).offset(4)
            $0.left.equalTo(title3)
        }
    }
}
