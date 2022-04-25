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

final class PolicyTermViewController: RunnerbeBaseViewController {
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
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBag)

        checkAllPolicyView.tapCheck
            .subscribe(onNext: { [weak self] check in
                self?.servicePolicyView.isSelected = check
                self?.privacyPolicyView.isSelected = check
                self?.locationPolicyView.isSelected = check
                self?.viewModel.inputs.tapServicePolicy.onNext(check)
                self?.viewModel.inputs.tapLocationPolicy.onNext(check)
                self?.viewModel.inputs.tapServicePolicy.onNext(check)
            })
            .disposed(by: disposeBag)

        servicePolicyView.tapCheck
            .subscribe(viewModel.inputs.tapServicePolicy)
            .disposed(by: disposeBag)

        privacyPolicyView.tapCheck
            .subscribe(viewModel.inputs.tapPrivacyPolicy)
            .disposed(by: disposeBag)

        locationPolicyView.tapCheck
            .subscribe(viewModel.inputs.tapLocationPolicy)
            .disposed(by: disposeBag)

        servicePolicyView.tapDetail
            .subscribe(viewModel.inputs.tapServiceDetail)
            .disposed(by: disposeBag)

        privacyPolicyView.tapDetail
            .subscribe(viewModel.inputs.tapPrivacyDetail)
            .disposed(by: disposeBag)

        locationPolicyView.tapDetail
            .subscribe(viewModel.inputs.tapLocationDetail)
            .disposed(by: disposeBag)
    }

    private func bindViewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: { [weak self] enable in
                self?.nextButton.isEnabled = enable
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private var titleLabel = UILabel().then { label in
        var font = UIFont.aggroLight.withSize(26)
        label.font = font
        label.setTextWithLineHeight(text: L10n.Onboarding.PolicyTerm.title, with: 42)
        label.textColor = UIColor.primary
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var policyContainerView = UIView().then { view in
        view.backgroundColor = .darkG6
        view.layer.cornerRadius = 10
    }

    private var checkAllPolicyView = CheckBoxView().then { view in
        view.labelText = L10n.Onboarding.PolicyTerm.Agree.All.title
        view.moreInfoButton.isHidden = true
        view.checkBoxButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var servicePolicyView = CheckBoxView().then { view in
        view.labelText = L10n.Onboarding.PolicyTerm.Agree.Service.title
        view.checkBoxButton.tintColor = .darkG35
        view.moreInfoButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var privacyPolicyView = CheckBoxView().then { view in
        view.labelText = L10n.Onboarding.PolicyTerm.Agree.Privacy.title
        view.checkBoxButton.tintColor = .darkG35
        view.moreInfoButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var locationPolicyView = CheckBoxView().then { view in
        view.labelText = L10n.Onboarding.PolicyTerm.Agree.Location.title
        view.checkBoxButton.tintColor = .darkG35
        view.moreInfoButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG1
        view.spacing = 12
        view.isSelected = false
    }

    private var policyHDividerView = UIView().then { view in
        view.backgroundColor = .darkG7
    }

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.Onboarding.PolicyTerm.Button.Next.title, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.Onboarding.PolicyTerm.Button.Next.title, for: .disabled)
        button.setTitleColor(UIColor.darkG4, for: .disabled)
        button.setBackgroundColor(UIColor.darkG5, for: .disabled)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true
        button.isEnabled = false
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.attributedText = NSMutableAttributedString()
            .style(to: "1", attributes: [
                .font: UIFont.iosBody17Sb,
                .foregroundColor: UIColor.primarydark,
            ])
            .style(to: "/4", attributes: [
                .font: UIFont.iosBody17Sb,
                .foregroundColor: UIColor.darkG35,
            ])
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension PolicyTermViewController {
    private func setupViews() {
        view.backgroundColor = .darkG7

        view.addSubviews([
            navBar,
            titleLabel,
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

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(114)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.width.equalTo(228)
            make.height.equalTo(84)
        }

        policyContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(64)
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
}
