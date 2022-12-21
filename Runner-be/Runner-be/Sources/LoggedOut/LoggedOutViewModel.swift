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
    private var userKeyChainService: UserKeychainService

    // MARK: Lifecycle

    init(loginService: LoginService = BasicLoginService(), userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared) {
        self.loginService = loginService
        self.userKeyChainService = userKeyChainService
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
                    print("KAKAO UUID \(uuid)")
                    self?.userKeyChainService.uuid = uuid
                    self?.routes.nonMember.onNext(())
                case .loginFail, .socialLoginFail:
                    self?.toast.onNext("로그인에 실패했습니다")
                case .stopped:
                    self?.toast.onNext("신고가 접수되어 계정이 정지되었어요")
                }
            })
            .disposed(by: disposeBag)

        inputs.naverLogin
            .map { [weak self] in self?.loginService.login(with: .naver) }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] result in
                print(result)
                switch result {
                case .member, .succeed:
                    self?.routes.loginSuccess.onNext(true)
                case .memberWaitCertification:
                    self?.routes.loginSuccess.onNext(false)
                case let .nonMember(uuid):
                    print("NAVER UUID \(uuid)")
                    self?.userKeyChainService.uuid = uuid
                    self?.routes.nonMember.onNext(())
                case .loginFail, .socialLoginFail:
                    self?.toast.onNext("로그인에 실패했습니다")
                case .stopped:
                    self?.toast.onNext("신고가 접수되어 계정이 정지되었어요")
                }
            })
            .disposed(by: disposeBag)

        inputs.appleLogin
            .map { [weak self] in self?.loginService.login(with: .apple(identifier: $0)) }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .member, .succeed:
                    print("LoginWithApple succeed, member")
                    self?.routes.loginSuccess.onNext(true)
                case .memberWaitCertification:
                    print("LoginWithApple memberWaitCertification")
                    self?.routes.loginSuccess.onNext(false)
                case let .nonMember(uuid):
                    print("LoginWithApple nonMember")
                    print("APPLE UUID \(uuid)")
                    self?.userKeyChainService.uuid = uuid
                    self?.routes.nonMember.onNext(())
                case .loginFail, .socialLoginFail:
                    self?.toast.onNext("로그인에 실패했습니다.")
                case .stopped:
                    self?.toast.onNext("신고가 접수되어 계정이 정지되었어요")
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        let kakaoLogin = PublishSubject<Void>()
        let naverLogin = PublishSubject<Void>()
        let appleLogin = PublishSubject<String>()
    }

    struct Output {
        let loginFail = PublishSubject<Void>()
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
