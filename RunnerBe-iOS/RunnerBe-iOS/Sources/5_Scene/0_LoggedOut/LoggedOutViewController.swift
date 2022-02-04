//
//  LoggedOutViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

final class LoggedOutViewController: BaseViewController {
    var logoImageView = UIImageView().then {
        $0.image = Asset.Images.logoSignature.uiImage
    }

    var kakaoButton = UIImageView().then {
        $0.image = Asset.Images.kakaoLogin.uiImage
        $0.contentMode = .scaleAspectFit
    }

    var naverButton = UIImageView().then {
        $0.image = Asset.Images.naverLogin.uiImage
        $0.contentMode = .scaleAspectFit
    }

    var appleButton = UIImageView().then {
        $0.image = Asset.Images.appleLogin.uiImage
        $0.contentMode = .scaleAspectFit
    }

    var viewModel: LoggedOutViewModel

    init(viewModel: LoggedOutViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layout()

        bindViewEvent()
        bindViewModelOutput()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func bindViewEvent() {
        kakaoButton.rx.tapGesture()
            .when(.recognized).map { _ in }
            .bind(to: viewModel.input.kakaoLogin)
            .disposed(by: disposeBags)

        naverButton.rx.tapGesture()
            .when(.recognized).map { _ in }
            .bind(to: viewModel.input.naverLogin)
            .disposed(by: disposeBags)

        appleButton.rx.tapGesture()
            .when(.recognized).map { _ in }
            .bind(to: viewModel.input.appleLogin)
            .disposed(by: disposeBags)
    }

    private func bindViewModelOutput() {}
}

// MARK: - Layout

private extension LoggedOutViewController {
    func configureView() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            Asset.Colors.bgGradientTop.uiColor.cgColor,
            Asset.Colors.bgGradientBottom.uiColor.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    func layout() {
        view.addSubview(logoImageView)
        let vStack = UIStackView.make(
            with: [kakaoButton, naverButton, appleButton],
            axis: .vertical,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: 16
        )
        view.addSubview(vStack)

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(180)
            make.centerX.equalTo(view.snp.centerX)
        }

        vStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-81)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
}
