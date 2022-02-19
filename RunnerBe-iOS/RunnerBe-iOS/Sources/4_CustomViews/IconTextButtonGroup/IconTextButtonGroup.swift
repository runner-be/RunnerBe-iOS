//
//  IconTextButtonGroup.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/19.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit

final class IconTextButtonGroup: UIStackView {
    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var iconLabelSpacing: CGFloat = 16 {
        didSet {
            setCustomSpacing(iconLabelSpacing, after: leftIcon)
        }
    }

    var leftIcon = UIImageView().then { view in
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    var titleLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = ""
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.backgroundColor = .clear
    }

    lazy var moreInfoButton = UIButton().then { button in
        button.setImage(Asset.chevronRight.uiImage.withTintColor(.darkG35), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    var icon: UIImage? {
        get { leftIcon.image }
        set { leftIcon.image = newValue }
    }

    var labelText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
}

// MARK: - Layout

extension IconTextButtonGroup {
    private func setupViews() {
        alignment = .center
        distribution = .fill

        addArrangedSubviews([leftIcon, titleLabel, moreInfoButton])
        setCustomSpacing(iconLabelSpacing, after: leftIcon)
    }

    private func initialLayout() {}
}
