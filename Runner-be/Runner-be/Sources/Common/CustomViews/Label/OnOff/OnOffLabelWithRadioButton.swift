//
//  OnOffLabelWithRadioButton.swift
//  Runner-be
//
//  Created by 이유리 on 3/24/24.
//

import UIKit

class OnOffLabelWithRadioButton: OnOffLabelButtonBase {
    // MARK: - Init

    init(
        iconSize: CGSize = CGSize(width: 20, height: 20),
        spacing: CGFloat = 4,
        padding: UIEdgeInsets = .zero
    ) {
        let radio = UIButton().then { view in
            view.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }
            view.setImage(Asset.registerRunningPaceRadioOff.image, for: .normal)
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

        super.init(button: radio, label: label)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func updateOnButtonAppearance() {
        button.setImage(
            isOn ?
                Asset.registerRunningPaceRadioOn.image :
                Asset.registerRunningPaceRadioOff.image,
            for: .normal
        )
    }
}

// final class OnOffLabelWithRadioButton: UIView {
//    var radio = UIButton().then { view in
//        view.snp.makeConstraints { make in
//            make.width.height.equalTo(20)
//        }
//        view.setImage(Asset.registerRunningPaceRadioOff.image, for: .normal)
//    }
//
//    var isOn = false {
//        didSet {
//            if isOn {
//                radio.setImage(Asset.registerRunningPaceRadioOn.image, for: .normal)
//            } else {
//                radio.setImage(Asset.registerRunningPaceRadioOff.image, for: .normal)
//            }
//        }
//    }
//
//    var label: IconLabel
//
//    init(
//        iconSize: CGSize = CGSize(width: 20, height: 20),
//        spacing: CGFloat = 4,
//        padding: UIEdgeInsets = .zero
//    ) {
//        label = IconLabel(
//            iconPosition: .left,
//            iconSize: iconSize,
//            spacing: spacing,
//            padding: padding
//        ).then {
//            $0.label.font = .pretendardRegular14
//            $0.label.textColor = .darkG3
//        }
//
//        super.init(frame: .zero)
//        setup()
//        initialLayout()
//    }
//
//    @available(*, unavailable)
//    required init?(coder _: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setup() {
//        addSubviews([
//            radio,
//            label,
//        ])
//    }
//
//    private func initialLayout() {
//        radio.snp.makeConstraints { make in
//            make.leading.top.bottom.equalToSuperview()
//        }
//
//        label.snp.makeConstraints { make in
//            make.leading.equalTo(radio.snp.trailing).offset(16)
//            make.top.bottom.equalToSuperview()
//        }
//    }
// }
