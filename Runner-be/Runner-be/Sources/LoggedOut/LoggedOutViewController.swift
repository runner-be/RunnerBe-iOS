//
//  LoggedOutViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import AuthenticationServices
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

final class LoggedOutViewController: BaseViewController {
    // MARK: Lifecycle

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

        setupViews()
        initialLayout()

        bindViewModelInput()
        bindViewModelOutput()
    }

    // MARK: ViewModel Binding

    private var viewModel: LoggedOutViewModel

    private func bindViewModelInput() {
        kakaoButton.rx.tapGesture()
            .debug()
            .when(.recognized).map { _ in }
            .bind(to: viewModel.inputs.kakaoLogin)
            .disposed(by: disposeBag)

        naverButton.rx.tapGesture()
            .debug()
            .when(.recognized).map { _ in }
            .bind(to: viewModel.inputs.naverLogin)
            .disposed(by: disposeBag)

        appleButton.rx.tapGesture()
            .debug()
            .when(.recognized).map { _ in }
            .subscribe(onNext: { [weak self] in
                let request = ASAuthorizationAppleIDProvider().createRequest()
                request.requestedScopes = [.fullName, .email]
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
                controller.performRequests()
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModelOutput() {
        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private var logoImageView = UIImageView().then {
        $0.image = Asset.logoSignature.uiImage
    }

    private var loginBtnVStackView = UIStackView.make(
        with: [],
        axis: .vertical,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 16
    )

    private var kakaoButton = UIImageView().then {
        $0.image = Asset.kakaoLogin.uiImage
        $0.contentMode = .scaleAspectFit
    }

    private var naverButton = UIImageView().then {
        $0.image = Asset.naverLogin.uiImage
        $0.contentMode = .scaleAspectFit
    }

    private var appleButton = UIImageView().then {
        $0.image = Asset.appleLogin.uiImage
        $0.contentMode = .scaleAspectFit
    }
}

// MARK: - Layout

extension LoggedOutViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubview(logoImageView)
        view.addSubview(loginBtnVStackView)
        loginBtnVStackView.addArrangedSubviews([
            kakaoButton,
            naverButton,
            appleButton,
        ])
    }

    private func initialLayout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(180)
            make.centerX.equalTo(view.snp.centerX)
        }

        loginBtnVStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
}

extension LoggedOutViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError _: Error) {}

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            viewModel.inputs.appleLogin.onNext(user)
            guard let email = credential.email else { return }
            print("Email: \(email)")
        }
    }
}
