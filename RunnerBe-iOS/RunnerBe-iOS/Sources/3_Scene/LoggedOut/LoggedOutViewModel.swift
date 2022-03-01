//
//  LoggedOutViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

final class LoggedOutViewModel: BaseViewModel {
    let loginService: LoginService
    private var signupKeyChainService: SignupKeyChainService

    // MARK: Lifecycle

    init(loginService: LoginService, signupKeyChainService: SignupKeyChainService) {
        self.loginService = loginService
        self.signupKeyChainService = signupKeyChainService
        super.init()

        inputs.kakaoLogin
            .debug()
            .map { [weak self] in self?.loginService.login(with: .kakao) }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .member, .succeed:
                    self?.routes.loginSuccess.onNext(true)
                case .memberWaitCertification:
                    self?.routes.loginSuccess.onNext(false)
                case let .nonMember(uuid):
                    self?.signupKeyChainService.uuid = uuid
                    self?.routes.nonMember.onNext(())
                case .loginFail, .socialLoginFail:
                    self?.outputs.toast.onNext("로그인에 실패했습니다")
                }
            })
            .disposed(by: disposeBag)

        inputs.naverLogin
            .map { [weak self] in self?.loginService.login(with: .naver) }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .member, .succeed:
                    self?.routes.loginSuccess.onNext(true)
                case .memberWaitCertification:
                    self?.routes.loginSuccess.onNext(false)
                case let .nonMember(uuid):
                    self?.signupKeyChainService.uuid = uuid
                    self?.routes.nonMember.onNext(())
                case .loginFail, .socialLoginFail:
                    self?.outputs.toast.onNext("로그인에 실패했습니다")
                }
            })
            .disposed(by: disposeBag)

        inputs.appleLogin.subscribe(onNext: { [weak self] in
            self?.routes.nonMember.onNext(())
        })
        .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        let kakaoLogin = PublishSubject<Void>()
        let naverLogin = PublishSubject<Void>()
        let appleLogin = PublishSubject<Void>()
    }

    struct Output {
        let loginFail = PublishSubject<Void>()
        let toast = PublishSubject<String>()
    }

    struct Route {
        let loginSuccess = PublishSubject<Bool>()
        let nonMember = PublishSubject<Void>()
    }

    let disposeBag = DisposeBag()
    let inputs = Input()
    let outputs = Output()
    let routes = Route()
}
