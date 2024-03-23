//
//  OnOffLabelWithRadioButton.swift
//  Runner-be
//
//  Created by 이유리 on 3/24/24.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class OnOffLabelWithRadioButton: UIView {
    var radio = UIButton().then { view in
        view.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        view.setImage(Asset.registerRunningPaceRadioOff.image, for: .normal)
    }

    var isOn = false {
        didSet {
            if isOn {
                radio.setImage(Asset.registerRunningPaceRadioOn.image, for: .normal)
            } else {
                radio.setImage(Asset.registerRunningPaceRadioOff.image, for: .normal)
            }
        }
    }

    var label = IconLabel(iconPosition: .left, iconSize: CGSize(width: 20, height: 20), spacing: 4).then { view in
        view.label.font = .pretendardRegular14
        view.label.textColor = .darkG3
    }

    init() {
        super.init(frame: .zero)
        setup()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubviews([
            radio,
            label,
        ])
    }

    private func initialLayout() {
        radio.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(radio.snp.trailing).offset(16)
            make.top.bottom.equalToSuperview()
        }
    }
}
