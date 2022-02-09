//
//  EmailCertificationViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class EmailCertificationViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInput()
        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: EmailCertificationViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: EmailCertificationViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBags)

        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNoEmail)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: {
                self.nextButton.isEnabled = $0
            })
            .disposed(by: disposeBags)
    }

    private func viewInput() {
        emailField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.emailField.layer.borderWidth = 1
            })
            .disposed(by: disposeBags)

        emailField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {
                self.emailField.layer.borderWidth = 0
            })
            .disposed(by: disposeBags)

        view.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] recognizer in
                guard let self = self else { return false }
                return !self.emailField.frame.contains(recognizer.location(in: self.view))
            }
            .subscribe(onNext: { [weak self] _ in
                self?.emailField.endEditing(true)
            })
            .disposed(by: disposeBags)
    }

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.text = L10n.SelectGender.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel1 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.EmailCertification.title1
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.EmailCertification.title2
    }

    private var subTitleLabel1 = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.EmailCertification.subTitle1
    }

    private var subTitleLabel2 = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.EmailCertification.subTitle2
    }

    private var emailField = TextFieldWithPadding().then { field in
        field.textPadding = UIEdgeInsets(top: 12, left: 14, bottom: 14, right: 14)
        field.backgroundColor = .darkG55
        field.font = .iosBody15R
        field.textAlignment = .left
        field.textColor = .darkG2
        field.attributedPlaceholder = NSAttributedString(
            string: L10n.EmailCertification.EmailField.placeholder,
            attributes: [.foregroundColor: UIColor.darkG35]
        )

        field.clipsToBounds = true
        field.layer.cornerRadius = 8
        field.layer.borderColor = UIColor.primary.cgColor

        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private var certificateButton = UIButton().then { button in
        button.setTitle(L10n.EmailCertification.Button.Certificate.title, for: .normal)
        button.setTitleColor(.darkG6, for: .normal)
        button.setBackgroundColor(.primary, for: .normal)
        button.setTitle(L10n.EmailCertification.Button.Certificate.title, for: .disabled)
        button.setTitleColor(.darkG45, for: .disabled)
        button.setBackgroundColor(.darkG3, for: .disabled)
        button.titleLabel?.font = .iosBody15B
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.setContentHuggingPriority(.required, for: .horizontal)
    }

    private var messageLabel1 = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .primary
        label.text = L10n.EmailCertification.Message.mailSend1
    }

    private var messageLabel2 = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .primary
        label.text = L10n.EmailCertification.Message.mailSend2
    }

    private var errorLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .errorlight
        label.text = L10n.EmailCertification.Error.duplicated
    }

    private lazy var messageVStack = UIStackView.make(
        with: [messageLabel1, messageLabel2, errorLabel],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 4
    )

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.EmailCertification.Button.NotHaveEmail.title, for: .normal)
        button.setTitleColor(UIColor.primary, for: .normal)
        button.setBackgroundColor(UIColor.clear, for: .normal)
        button.titleLabel?.font = .iosBody15B

        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1

        button.clipsToBounds = true
        // TODO: 임시로 버튼 활성화
//        button.isEnabled = false
    }
}

// MARK: - Layout

extension EmailCertificationViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,

            titleLabel1,
            titleLabel2,
            subTitleLabel1,
            subTitleLabel2,

            emailField,
            certificateButton,

            messageVStack,

            nextButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(26)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        subTitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(18)
        }

        subTitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(18)
        }

        emailField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel2.snp.bottom).offset(72)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        certificateButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.top)
            make.leading.equalTo(emailField.snp.trailing).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(emailField.snp.bottom)
            make.width.equalTo(92)
        }

        messageVStack.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        nextButton.layer.cornerRadius = 24
    }

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.bgBottom.cgColor,
            UIColor.bgTop.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
