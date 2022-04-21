//
//  OnboardingCoverViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/04.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class OnboardingCoverViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: OnboardingCoverViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: OnboardingCoverViewModel

    private func viewModelInput() {
        cancelBtn.rx.tap
            .bind(to: viewModel.inputs.lookMain)
            .disposed(by: disposeBag)

        onboardBtn.rx.tap
            .bind(to: viewModel.inputs.goOnboard)
            .disposed(by: disposeBag)

        testCertificated.rx.tap
            .bind(to: viewModel.inputs.testCertificated)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}

    private var titleLabel = UILabel().then { label in
        label.textColor = .darkG1
        label.font = .iosHeader31Sb
        label.text = L10n.Onboard.Cover.title
        label.numberOfLines = 2
        label.textAlignment = .center
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var titleIcon = UIImageView().then { view in
        view.image = Asset.logo.uiImage
        view.snp.makeConstraints { make in
            make.width.equalTo(136)
            make.height.equalTo(136)
        }
    }

    private var onboardBtn = UIButton().then { button in
        button.setTitle(L10n.Onboard.Cover.Button.Onboard.title, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.titleLabel?.font = .iosBody15B
        button.clipsToBounds = true

        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        button.layer.cornerRadius = 24
    }

    private var cancelBtn = UIButton().then { button in
        let attributedString = NSAttributedString(
            string: L10n.Onboard.Cover.Button.LookAround.title,
            attributes: [
                .font: UIFont.iosBody13R,
                .foregroundColor: UIColor.darkG35,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.darkG25,
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
    }

    private var testCertificated = UIButton().then { button in
        button.setTitle("CERTIFICATED", for: .normal)
        button.setTitleColor(.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.titleLabel?.font = .iosBody17R

        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.isHidden = true
    }
}

// MARK: - Layout

extension OnboardingCoverViewController {
    private func setupViews() {
        view.backgroundColor = .darkBlack.withAlphaComponent(0.7)

        view.addSubviews([
            titleLabel,
            titleIcon,
            onboardBtn,
            cancelBtn,

            // TEST
            testCertificated,
        ])
    }

    private func initialLayout() {
        titleIcon.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleIcon.snp.top).offset(-28)
            make.leading.equalTo(view.snp.leading).offset(38)
            make.trailing.equalTo(view.snp.trailing).offset(-38)
        }

        onboardBtn.snp.makeConstraints { make in
            make.top.equalTo(titleIcon.snp.bottom).offset(40)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(onboardBtn.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
        }

        testCertificated.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
    }
}
