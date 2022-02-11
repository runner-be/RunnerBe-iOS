//
//  PolicyTermViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit

final class PolicyTermViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        bindViewModelInput()
        bindViewModelOutput()
    }

    init(viewModel: PolicyTermViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    var viewModel: PolicyTermViewModel

    private func bindViewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBags)

        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBags)

        checkAllPolicyView.tapCheck
            .subscribe(onNext: { [weak self] check in
                self?.servicePolicyView.isSelected = check
                self?.privacyPolicyView.isSelected = check
                self?.locationPolicyView.isSelected = check
                self?.viewModel.inputs.tapServicePolicy.onNext(check)
                self?.viewModel.inputs.tapLocationPolicy.onNext(check)
                self?.viewModel.inputs.tapServicePolicy.onNext(check)
            })
            .disposed(by: disposeBags)

        servicePolicyView.tapCheck
            .subscribe(viewModel.inputs.tapServicePolicy)
            .disposed(by: disposeBags)

        privacyPolicyView.tapCheck
            .subscribe(viewModel.inputs.tapPrivacyPolicy)
            .disposed(by: disposeBags)

        locationPolicyView.tapCheck
            .subscribe(viewModel.inputs.tapLocationPolicy)
            .disposed(by: disposeBags)

        servicePolicyView.tapDetail
            .subscribe(viewModel.inputs.tapServiceDetail)
            .disposed(by: disposeBags)

        privacyPolicyView.tapDetail
            .subscribe(viewModel.inputs.tapPrivacyDetail)
            .disposed(by: disposeBags)

        locationPolicyView.tapDetail
            .subscribe(viewModel.inputs.tapLocationDetail)
            .disposed(by: disposeBags)
    }

    private func bindViewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: { [weak self] enable in
                self?.nextButton.isEnabled = enable
            })
            .disposed(by: disposeBags)
    }

    // MARK: Private

    private var titleLabel1 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.text = L10n.PolicyTerm.title1
        label.textColor = UIColor.primary
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.text = L10n.PolicyTerm.title2
        label.textColor = UIColor.primary
    }

    private var policyContainerView = UIView().then { view in
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.darkG35.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
    }

    private var checkAllPolicyView = CheckBoxView().then { view in
        view.labelText = L10n.PolicyTerm.Agree.All.title
        view.moreInfoButton.isHidden = true
        view.checkBoxButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var servicePolicyView = CheckBoxView().then { view in
        view.labelText = L10n.PolicyTerm.Agree.Service.title
        view.checkBoxButton.tintColor = .darkG35
        view.moreInfoButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var privacyPolicyView = CheckBoxView().then { view in
        view.labelText = L10n.PolicyTerm.Agree.Privacy.title
        view.checkBoxButton.tintColor = .darkG35
        view.moreInfoButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var locationPolicyView = CheckBoxView().then { view in
        view.labelText = L10n.PolicyTerm.Agree.Location.title
        view.checkBoxButton.tintColor = .darkG35
        view.moreInfoButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var policyHDividerView = UIView().then { view in
        view.backgroundColor = .darkG35
    }

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.PolicyTerm.Button.Next.title, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.PolicyTerm.Button.Next.title, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.titleLabel?.font = .iosBody15R

        button.clipsToBounds = true
        button.isEnabled = false
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = ""
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension PolicyTermViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            titleLabel1,
            titleLabel2,
            policyContainerView,
            nextButton,
        ])

        policyContainerView.addSubviews([
            checkAllPolicyView,
            policyHDividerView,
            servicePolicyView,
            privacyPolicyView,
            locationPolicyView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide
                .snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(114)
            make.leading.equalTo(view.snp.leading).offset(16)
        }
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.leading.equalTo(titleLabel1.snp.leading)
        }

        policyContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(76)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        checkAllPolicyView.snp.makeConstraints { make in
            make.top.equalTo(policyContainerView.snp.top).offset(24)
            make.leading.equalTo(policyContainerView.snp.leading).offset(12)
            make.trailing.equalTo(policyContainerView.snp.trailing).offset(12)
        }

        policyHDividerView.snp.makeConstraints { make in
            make.top.equalTo(checkAllPolicyView.snp.bottom).offset(23)
            make.leading.equalTo(policyContainerView.snp.leading)
            make.trailing.equalTo(policyContainerView.snp.trailing)
            make.height.equalTo(1)
        }

        servicePolicyView.snp.makeConstraints { make in
            make.top.equalTo(policyHDividerView.snp.bottom).offset(24)
            make.leading.equalTo(policyContainerView.snp.leading).offset(12)
            make.trailing.equalTo(policyContainerView.snp.trailing).offset(-12)
        }

        privacyPolicyView.snp.makeConstraints { make in
            make.top.equalTo(servicePolicyView.snp.bottom).offset(24)
            make.leading.equalTo(policyContainerView.snp.leading).offset(12)
            make.trailing.equalTo(policyContainerView.snp.trailing).offset(-12)
        }

        locationPolicyView.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyView.snp.bottom).offset(24)
            make.leading.equalTo(policyContainerView.snp.leading).offset(12)
            make.trailing.equalTo(policyContainerView.snp.trailing).offset(-12)
            make.bottom.equalTo(policyContainerView.snp.bottom).offset(-28)
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
