//
//  WaitOnboradingViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/05.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class WaitOnboardingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: WaitOnboardingCoverViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WaitOnboardingCoverViewModel

    private func viewModelInput() {
        toMain.rx.tap
            .bind(to: viewModel.inputs.toMain)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {}

    private var titleLabel = UILabel().then { label in
        label.textColor = .primary
        label.font = .iosHeader31Sb
        label.text = L10n.Onboard.Wait.title
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

    private var toMain = UIButton().then { button in
        button.setTitle(L10n.Onboard.Wait.Button.title, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.titleLabel?.font = .iosBody15B
        button.clipsToBounds = true

        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        button.layer.cornerRadius = 24
    }
}

// MARK: - Layout

extension WaitOnboardingViewController {
    private func setupViews() {
        view.backgroundColor = .darkBlack.withAlphaComponent(0.7)

        view.addSubviews([
            titleLabel,
            titleIcon,
            toMain,
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

        toMain.snp.makeConstraints { make in
            make.top.equalTo(titleIcon.snp.bottom).offset(40)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }
    }
}
