//
//  SelectNickNameView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

final class TextFieldWithButton: SelectBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPlaceHolder(to text: String) {
        nickNameField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.darkG35]
        )
    }

    func disableWithPlaceHolder(fieldText: String?, buttonText: String?) {
        applyButton.isEnabled = false
        nickNameField.isEnabled = false

        if let field = fieldText {
            setPlaceHolder(to: field)
            nickNameField.text = ""
        }

        if buttonText != nil {
            applyButton.setTitle(buttonText, for: .disabled)
        }
    }

    var nickNameField = TextFieldWithPadding().then { field in
        field.textPadding = UIEdgeInsets(top: 12, left: 14, bottom: 14, right: 14)
        field.backgroundColor = .darkG55
        field.font = .iosBody15R
        field.textAlignment = .left
        field.textColor = .darkG2
        field.attributedPlaceholder = NSAttributedString(
            string: L10n.EmailCertification.EmailField.placeholder,
            attributes: [.foregroundColor: UIColor.darkG35]
        )
        field.autocapitalizationType = .none
        field.autocorrectionType = .no

        field.clipsToBounds = true
        field.layer.cornerRadius = 8
        field.layer.borderColor = UIColor.primary.cgColor

        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    var applyButton = UIButton().then { button in

        button.setTitleColor(.darkG6, for: .normal)
        button.setBackgroundColor(.primary, for: .normal)

        button.setTitleColor(.darkG45, for: .disabled)
        button.setBackgroundColor(.darkG3, for: .disabled)
        button.titleLabel?.font = .iosBody15B
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.setContentHuggingPriority(.required, for: .horizontal)

        button.isEnabled = false
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Gender.title

        contentView.addSubviews([nickNameField, applyButton])
    }

    override func initialLayout() {
        super.initialLayout()

        nickNameField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(contentView.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        applyButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameField.snp.top)
            make.leading.equalTo(nickNameField.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(nickNameField.snp.bottom)
            make.width.equalTo(92)
        }
    }
}
