//
//  OnOffLabelWithCheckBoxButton.swift
//  Runner-be
//
//  Created by 김창규 on 8/10/24.
//

import UIKit

class OnOffLabelWithCheckBoxButton: OnOffLabelButtonBase {
    // MARK: - Init

    init(
        iconSize: CGSize = CGSize(width: 20, height: 20),
        spacing: CGFloat = 4,
        padding: UIEdgeInsets = .zero
    ) {
        let checkBox = UIButton().then {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(24)
            }
            $0.setImage(
                Asset.registerRunningPaceCheckboxOff.image,
                for: .normal
            )
        }

        let label = IconLabel(
            iconPosition: .left,
            iconSize: iconSize,
            spacing: spacing,
            padding: padding
        ).then {
            $0.label.font = .pretendardRegular14
            $0.label.textColor = .darkG3
        }

        super.init(button: checkBox, label: label)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func updateOnButtonAppearance() {
        button.setImage(
            isOn ?
                Asset.registerRunningPaceCheckboxOn.image :
                Asset.registerRunningPaceCheckboxOff.image,
            for: .normal
        )
    }

    override func updateDisableButtonAppearance() {
        button.setImage(
            isDisable ?
                Asset.registerRunningPaceCheckboxOnDisable.image :
                Asset.registerRunningPaceCheckboxOff.image,
            for: .normal
        )
    }
}
