//
//  SelectJobGroupViewController.swift
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

class SelectJobGroupViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SelectJobGroupViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: SelectJobGroupViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBags)

        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: {
                self.nextButton.isEnabled = $0
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
        label.text = L10n.SelectJobGroup.title1
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.SelectJobGroup.title2
    }

    private var subTitleLabel = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.SelectJobGroup.subTitle
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
        // TODO: 임시로 버튼 활성화
//        button.isEnabled = false
    }
}

// MARK: - Layout

extension SelectJobGroupViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            titleLabel1,
            titleLabel2,
            subTitleLabel,

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

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(18)
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
