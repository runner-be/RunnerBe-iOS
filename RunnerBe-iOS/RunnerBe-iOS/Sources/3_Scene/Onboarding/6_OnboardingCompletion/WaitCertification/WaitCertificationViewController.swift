//
//  WaitCertificationViewController.swift
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

class WaitCertificationViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: WaitCertificationViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WaitCertificationViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}

    private var titleLabel = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.WaitCertification.title1
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var subTitleLabel = UILabel().then { label in
        label.attributedText = NSMutableAttributedString()
            .style(to: L10n.WaitCertification.SubTitle1._1,
                   attributes: [
                       .font: UIFont.iosBody15R,
                       .foregroundColor: UIColor.darkG25,
                   ])
            .style(to: L10n.WaitCertification.SubTitle1._2,
                   attributes: [
                       .font: UIFont.iosBody15R,
                       .foregroundColor: UIColor.darkG25,
                       .underlineStyle: NSUnderlineStyle.single.rawValue,
                       .underlineColor: UIColor.darkG25,
                   ])
            .style(to: L10n.WaitCertification.SubTitle1._3,
                   attributes: [
                       .font: UIFont.iosBody15R,
                       .foregroundColor: UIColor.darkG25,
                   ])
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var iconView = UILabel().then { label in
        label.font = label.font.withSize(100)
        label.textAlignment = .center
        label.text = "✅"
    }

    private var toMainButton = UIButton().then { button in
        button.setTitle(L10n.WaitCertification.Button.toMain, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true

        button.isEnabled = true
    }
}

// MARK: - Layout

extension WaitCertificationViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            titleLabel,
            subTitleLabel,
            iconView,

            toMainButton,
        ])
    }

    private func initialLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(114)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-78)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(18)
            make.trailing.equalTo(view.snp.trailing).offset(-73)
        }

        iconView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(400)
            make.centerX.equalTo(view.snp.centerX)
        }

        toMainButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        toMainButton.layer.cornerRadius = 24
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
