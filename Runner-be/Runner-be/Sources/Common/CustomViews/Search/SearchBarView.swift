//
//  SearchBarView.swift
//  Runner-be
//
//  Created by 김창규 on 8/21/24.
//

import RxSwift
import UIKit

final class SearchBarView: UIView {
    // MARK: - Properties

    private let disposeBag = DisposeBag()

    // MARK: - UI

    private let icon = UIImageView()

    let cancelButton = UIImageView(image: Asset.circleCancelGray.uiImage)

    let textField = UITextField().then {
        let placeholderText = "모임 장소 검색"
        let placeholderFont = UIFont.pretendardRegular16
        let placeholderColor = UIColor.darkG35 // 원하는 색상으로 변경

        $0.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .font: placeholderFont,
                .foregroundColor: placeholderColor,
            ]
        )

        $0.font = .pretendardRegular16
        $0.textColor = .darkG1
        $0.tintColor = .primary
    }

    // MARK: - Init

    init(
        iconImage: UIImage = Asset.iconSearch18.uiImage,
        placeHolder: String
    ) {
        icon.image = iconImage
        textField.placeholder = placeHolder
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
            icon,
            textField,
            cancelButton,
        ])
    }

    private func initialLayout() {
        icon.snp.makeConstraints {
            $0.left.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }

        cancelButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        textField.snp.makeConstraints {
            $0.left.equalTo(icon.snp.right).offset(4)
            $0.top.bottom.equalToSuperview().inset(11)
            $0.right.equalTo(cancelButton.snp.left).inset(-8)
        }
    }
}
