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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showContentViewAnimation()
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
        closeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideContentViewAnimation()
            })
            .disposed(by: disposeBag)

        cancelBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideContentViewAnimation()
            })
            .disposed(by: disposeBag)

        onboardBtn.rx.tap
            .bind(to: viewModel.inputs.goOnboard)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}

    private func showContentViewAnimation() {
        contentViewBottom.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideContentViewAnimation() {
        contentViewBottom.constant = 366 + AppContext.shared.safeAreaInsets.bottom
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.viewModel.inputs.lookMain.onNext(())
            }
        )
    }

    private var dimView = UIView().then { view in
        view.backgroundColor = .darkBlack.withAlphaComponent(0.7)
    }

    private var contentView = UIView().then { view in
        view.backgroundColor = .darkG6

        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
    }

    private lazy var contentViewBottom = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 366 + AppContext.shared.safeAreaInsets.bottom)

    private var closeBtn = UIButton().then { button in
        button.setImage(Asset.x.uiImage, for: .normal)

        button.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }

    private var titleLabel = UILabel().then { label in
        var font = UIFont.aggroLight.withSize(22)
        label.font = font
        label.setTextWithLineHeight(text: L10n.Onboard.Cover.title, with: 35.2)
        label.textColor = .darkG1
        label.textAlignment = .center
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var titleIcon = UIImageView().then { view in
        view.image = Asset.lockLocked.uiImage
        view.snp.makeConstraints { make in
            make.width.equalTo(96)
            make.height.equalTo(96)
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
}

// MARK: - Layout

extension OnboardingCoverViewController {
    private func setupViews() {
        view.addSubviews([
            dimView,
            contentView,
        ])

        contentView.addSubviews([
            closeBtn,
            titleLabel,
            titleIcon,
            onboardBtn,
            cancelBtn,
        ])
    }

    private func initialLayout() {
        dimView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            make.height.equalTo(366 + AppContext.shared.safeAreaInsets.bottom) // close: 0 open: 255
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        contentViewBottom.isActive = true

        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(40)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        titleIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        onboardBtn.snp.makeConstraints { make in
            make.top.equalTo(titleIcon.snp.bottom).offset(29)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(280)
        }

        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(onboardBtn.snp.bottom).offset(16)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
}
