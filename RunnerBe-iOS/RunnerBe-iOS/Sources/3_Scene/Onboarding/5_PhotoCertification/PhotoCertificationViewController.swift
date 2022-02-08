//
//  PhotoCertificationViewController.swift
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

class PhotoCertificationViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: PhotoCertificationViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: PhotoCertificationViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.text = L10n.PhotoCertification.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel1 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.PhotoCertification.title1
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.PhotoCertification.title2
    }

    private var subTitleLabel1 = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.subTitle1
    }

    private var subTitleLabel2 = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.subTitle2
    }

    private var photoView = PhotoChoosableView().then { view in
        view.layer.borderColor = UIColor.darkG25.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
    }

    private var ruleLabel1 = UILabel().then { label in
        label.attributedText = NSMutableAttributedString()
            .style(to: L10n.PhotoCertification.ImageRule.emoji,
                   attributes: [
                       .font: UIFont.iosBody15R,
                       .foregroundColor: UIColor.darkG25,
                   ])
            .style(to: L10n.PhotoCertification.ImageRule.No1.highlighted,
                   attributes: [
                       .font: UIFont.iosBody15B,
                       .foregroundColor: UIColor.darkG25,
                       .underlineStyle: NSUnderlineStyle.single.rawValue,
                       .underlineColor: UIColor.darkG25,
                   ])
            .style(to: L10n.PhotoCertification.ImageRule.No1.normal,
                   attributes: [
                       .font: UIFont.iosBody15R,
                       .foregroundColor: UIColor.darkG25,
                   ])
    }

    private var ruleLabel2 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.ImageRule.emoji
            + L10n.PhotoCertification.ImageRule.no2
    }

    private var ruleLabel3 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.ImageRule.emoji
            + L10n.PhotoCertification.ImageRule.no3
    }

    private lazy var ruleLabelVStack = UIStackView.make(
        with: [ruleLabel1, ruleLabel2, ruleLabel3],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 2
    )

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.PhotoCertification.Button.Certificate.title, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.PhotoCertification.Button.Certificate.title, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.titleLabel?.font = .iosBody15R

        button.clipsToBounds = true
        // TODO: 임시로 버튼 활성화
//        button.isEnabled = false
    }
}

// MARK: - Layout

extension PhotoCertificationViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            titleLabel1,
            titleLabel2,
            subTitleLabel1,
            subTitleLabel2,
            photoView,
            ruleLabelVStack,

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

        photoView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel2.snp.bottom).offset(76)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(193)
        }

        ruleLabelVStack.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(24)
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
