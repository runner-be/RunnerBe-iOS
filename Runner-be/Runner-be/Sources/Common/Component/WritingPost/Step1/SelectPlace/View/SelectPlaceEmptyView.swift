//
//  SelectPlaceEmptyView.swift
//  Runner-be
//
//  Created by 김창규 on 8/21/24.
//

import UIKit

final class SelectPlaceEmptyView: UIView {
    // MARK: - UI

    private let emptyIcon = UIImageView(image: Asset.iconEmpty72.uiImage)

    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.textColor = .darkG3
        $0.font = .pretendardRegular18
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

extension SelectPlaceEmptyView {
    private func setupViews() {
        addSubviews([
            emptyIcon,
            emptyLabel,
        ])
    }

    private func initialLayout() {
        emptyIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152.5)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(72)
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyIcon.snp.bottom).offset(16)
            $0.centerX.equalTo(emptyIcon)
        }
    }
}
