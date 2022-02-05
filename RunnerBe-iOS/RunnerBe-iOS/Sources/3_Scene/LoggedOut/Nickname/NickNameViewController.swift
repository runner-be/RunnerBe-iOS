//
//  NickNameViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import UIKit

class NickNameViewController: BaseViewController {
    // MARK: Lifecycle

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gradientBackground()
        initialLayout()
    }

    // MARK: Internal

    let titleLabel1 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.text = L10n.NickName.title1
        label.textColor = UIColor.primary
    }

    let titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.text = L10n.NickName.title2
        label.textColor = UIColor.primary
    }

    let subtitleLabel = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.text = L10n.NickName.subtitle
        label.textColor = UIColor.darkG25
    }

    let nickNameTextField = UITextField().then { field in
        field.font = UIFont.iosBody15R
        field.placeholder = L10n.NickName.Textfield.placeholder
        field.backgroundColor = UIColor.darkG35
        field.layer.cornerRadius = 3
    }

    let checkDupButton = UIButton(type: .system).then { button in
        button.titleLabel?.font = UIFont.iosBody15R
        button.titleLabel?.text = L10n.NickName.Button.CheckDup.title
        button.titleLabel?.textColor = UIColor.darkG45
        button.backgroundColor = UIColor.darkG3

        button.clipsToBounds = true
        button.layer.cornerRadius = 5
    }

    let errorStackView = UIStackView.make(
        with: [],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,

        spacing: 2
    )

    let nickNameFormatErrorLabel = UILabel().then { label in
        label.font = UIFont.iosBody13R
        label.text = L10n.NickName.Error.textformat
        label.textColor = UIColor.errorlight
    }

    let nickNameDupErrorLabel = UILabel().then { label in
        label.font = UIFont.iosBody13R
        label.text = L10n.NickName.Error.duplicated
        label.textColor = UIColor.errorlight
    }

    let setNickNameButton = UIButton(type: .system).then { button in
        button.titleLabel?.font = UIFont.iosBody15R
        button.titleLabel?.text = L10n.NickName.Button.SetNickname.title
        button.titleLabel?.textColor = UIColor.darkG45
        button.backgroundColor = UIColor.darkG3

        button.clipsToBounds = true
    }
}

// MARK: - Layout

extension NickNameViewController {
    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.darkG55.cgColor,
            UIColor.darkG6.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    private func initialLayout() {
        let titleStackView = UIStackView.make(
            with: [titleLabel1, titleLabel2],
            axis: .vertical,
            alignment: .leading,
            distribution: .equalSpacing,
            spacing: 2
        )
        view.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(114)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        view.addSubview(nickNameTextField)
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(56)
            make.leading.equalTo(view.snp.leading).offset(16)
        }
        nickNameTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        view.addSubview(checkDupButton)
        checkDupButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.top)
            make.leading.equalTo(nickNameTextField.snp.trailing).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        view.addSubview(errorStackView)
        errorStackView.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        view.addSubview(setNickNameButton)
        setNickNameButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-82)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }
    }
}
