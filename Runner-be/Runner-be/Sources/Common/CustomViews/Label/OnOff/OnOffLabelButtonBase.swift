//
//  OnOffLabelButtonBase.swift
//  Runner-be
//
//  Created by 김창규 on 8/10/24.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class OnOffLabelButtonBase: UIView {
    // MARK: - UI

    var button: UIButton
    var label: IconLabel
    var isOn: Bool = false {
        didSet {
            if isDisable {
                return
            }
            updateOnButtonAppearance()
        }
    }

    var isDisable: Bool = false {
        didSet {
            updateDisableButtonAppearance()
        }
    }

    // MARK: - Init

    init(
        button: UIButton,
        label: IconLabel
    ) {
        self.button = button
        self.label = label
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func updateOnButtonAppearance() {
        // 자식 클래스에서 오버라이드하여 구현
    }

    func updateDisableButtonAppearance() {
        // 자식 클래스에서 오버라이드하여 구현
    }
}

// MARK: - Layout

extension OnOffLabelButtonBase {
    private func setupViews() {
        addSubviews([button, label])
    }

    private func initialLayout() {
        button.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(24)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.trailing).offset(16)
            make.top.bottom.equalToSuperview()
        }
    }
}
