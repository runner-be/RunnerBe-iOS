//
//  OnboardingCompletionViewController.swift
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

class OnboardingCompletionViewController: RunnerbeBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: OnboardingCompletionViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: OnboardingCompletionViewModel

    private func viewModelInput() {
        startButton.rx.tap
            .bind(to: viewModel.inputs.tapStart)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}

    // MARK: Private

    var titleLabel = UILabel().then { label in
        var font = UIFont.aggroLight.withSize(22)
        label.font = font
        label.setTextWithLineHeight(text: L10n.OnboardingCompletion.title, with: 35.2)
        label.textColor = .primary
        label.textAlignment = .center
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    var subTitleLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG25
        label.text = L10n.OnboardingCompletion.subTitle
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    var iconImageView = UIImageView().then { imageView in
        imageView.image = Asset.onboardingCompletion.uiImage
    }

    private var startButton = UIButton().then { button in
        button.setTitle(L10n.OnboardingCompletion.Button.start, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true

        button.isEnabled = true
    }
}

// MARK: - Layout

extension OnboardingCompletionViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            titleLabel,
            subTitleLabel,
            iconImageView,
            startButton,
        ])
    }

    private func initialLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(178)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(248)
            make.height.equalTo(216)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(32)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(240)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalTo(view.snp.centerX)
        }

        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        startButton.layer.cornerRadius = 24
    }
}
