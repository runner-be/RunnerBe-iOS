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
            .flatMap { loginService.login(with: .kakao) }
            .subscribe(onNext: { result in
                switch result {
                case .member, .succeed:
                    self.routes.loginSuccess.onNext(())
                case let .nonMember(uuid):
                    self.signupKeyChainService.uuid = uuid
                    self.routes.nonMember.onNext(())
                case .loginFail, .socialLoginFail:
                    // TODO: 로그인 실패시 어떻게 처리
                    break
                }
            })
            .disposed(by: disposeBag)

        inputs.naverLogin
            .flatMap { loginService.login(with: .naver) }
            .subscribe(onNext: { result in
                switch result {
                case .member, .succeed:
                    self.routes.loginSuccess.onNext(())
                case let .nonMember(uuid):
                    self.signupKeyChainService.uuid = uuid
                    self.routes.nonMember.onNext(())
                case .loginFail, .socialLoginFail:
                    // TODO: 로그인 실패시 어떻게 처리
                    break
                }
            })
            .disposed(by: disposeBag)

        inputs.appleLogin.subscribe(onNext: {
            self.routes.nonMember.onNext(())
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
    }

    struct Route {
        let loginSuccess = PublishSubject<Void>()
        let nonMember = PublishSubject<Void>()
    }

    let disposeBag = DisposeBag()
    let inputs = Input()
    let outputs = Output()
    let routes = Route()
}
