//
//  SearchBarView.swift
//  Runner-be
//
//  Created by 김창규 on 8/21/24.
//

import UIKit

final class SearchBarView: UIView {
    // MARK: - UI

    private let placeHolderLabel = IconLabel(
        iconPosition: .left,
        iconSize: CGSize(width: 18, height: 18),
        spacing: 4,
        padding: .zero
    ).then {
        $0.icon.image = Asset.iconSearch18.uiImage
        $0.label.font = .pretendardRegular16
        $0.label.textColor = .darkG35
        $0.label.text = "PlaceHolder"
    }

    // MARK: - Init

    init(placeHolder: String) {
        placeHolderLabel.label.text = placeHolder
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

extension SearchBarView {
    private func setupViews() {
        backgroundColor = .white.withAlphaComponent(0.04)

        addSubviews([
            placeHolderLabel,
        ])
    }

    private func initialLayout() {
        placeHolderLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }
}
