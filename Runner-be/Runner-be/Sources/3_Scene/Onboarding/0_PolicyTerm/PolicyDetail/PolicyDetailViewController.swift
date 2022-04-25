//
//  PolicyDetailViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class PolicyDetailViewController: RunnerbeBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: PolicyDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: PolicyDetailViewModel

    private func viewModelInput() {
        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapClose)
            .disposed(by: disposeBag)

        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapClose)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.modalPresented
            .take(1)
            .subscribe(onNext: { [weak self] modal in
                self?.setupBarStyle(modal: modal)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.text
            .take(1)
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.title
            .take(1)
            .bind(to: navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupBarStyle(modal: Bool) {
        if modal {
            navBar.rightBtnItem.isHidden = false
            navBar.leftBtnItem.isHidden = true
        } else {
            navBar.leftBtnItem.isHidden = false
            navBar.rightBtnItem.isHidden = true
        }
    }

    // MARK: private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.Onboarding.PolicyDetail.NavBar.title
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
        navBar.leftBtnItem.isHidden = true
    }

    private var textView = UITextView().then { view in
        view.backgroundColor = .clear
        view.font = .iosBody13R
        view.textColor = .darkG1
        view.isEditable = false
        view.isScrollEnabled = true
    }
}

// MARK: - Layout

extension PolicyDetailViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            textView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide
                .snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(118)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
        }
    }
}
