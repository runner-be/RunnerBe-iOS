//
//  RegisterRunningPaceView.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import SnapKit
import Then
import UIKit

final class RegisterRunningPaceView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var radioButton = UIButton().then { view in
        view.setImage(Asset.registerRunningPaceRadioOff.uiImage, for: .normal)
        view.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        view.isUserInteractionEnabled = false
    }

    var icon = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }

    var titleLabel = UILabel().then { view in
        view.font = .pretendardSemiBold16
        view.textColor = .darkG2
    }

    var subTitleLabel = UILabel().then { view in
        view.font = .pretendardRegular14
        view.textColor = .darkG2
    }
}

extension RegisterRunningPaceView {
    func setupViews() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .darkG5

        addSubviews([
            radioButton,
            icon,
            titleLabel,
            subTitleLabel,
        ])
    }

    func initialLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(70)
        }

        radioButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }

        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(radioButton.snp.trailing).offset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(icon.snp.trailing).offset(4)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(icon.snp.leading)
        }
    }
}
