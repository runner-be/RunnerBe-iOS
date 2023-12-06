//
//  BasicLoginService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

final class BasicLoginService: LoginService {
    private var disposeBag = DisposeBag()

    private var loginKeyChainService: LoginKeyChainService
    private var userKeyChainService: UserKeychainService
    private let kakaoLoginService: SocialLoginService
    private let naverLoginService: SocialLoginService
    private let loginAPIService: LoginAPIService

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        userKeyChainService: UserKeychainService = BasicUserKeyChainService.shared,
        loginAPIService: LoginAPIService = BasicLoginAPIService(),
        kakaoLoginService: SocialLoginService = KakaoLoginService(),
        naverLoginService: SocialLoginService = NaverLoginService()
    ) {
        self.kakaoLoginService = kakaoLoginService
        self.naverLoginService = naverLoginService
        self.loginAPIService = loginAPIService
        self.loginKeyChainService = loginKeyChainService
        self.userKeyChainService = userKeyChainService
    }

    func checkLogin() -> Observable<CheckLoginResult> {
        guard let token = loginKeyChainService.token
        else {
            logout()
            return .just(.nonMember)
        }

        return loginAPIService.login(with: token)
            .timeout(.seconds(3), other: Observable.just(.nonMember), scheduler: MainScheduler.instance)
            .map { [weak self] result in
                switch result {
                case .member:
                    self?.loginKeyChainService.loginType = .member
                    return .member
                case .nonMember:
                    self?.loginKeyChainService.loginType = .nonMember
                    self?.logout()
                    return .nonMember
                case .waitCertification:
                    self?.loginKeyChainService.loginType = .waitCertification
                    return .memberWaitCertification
                case .stopped:
                    self?.loginKeyChainService.loginType = .stopped
                    return .stopped
                }
            }
    }

    func login(with socialType: SocialLoginType) -> Observable<LoginResult> {
        let functionResult = ReplaySubject<LoginResult>.create(bufferSize: 1)

        let socialLoginResult: Observable<SocialLoginResult?>
        switch socialType {
        case .naver:
            socialLoginResult = naverLoginService.login()
        case .kakao:
            socialLoginResult = kakaoLoginService.login()
        case .apple:
            socialLoginResult = .just(SocialLoginResult(token: "", loginType: socialType))
        }

        socialLoginResult
            .compactMap {
                if let result = $0 {
                    return result
                }
                functionResult.onNext(.socialLoginFail)
                return nil
            }
            .flatMap { [unowned self] (socialLogin: SocialLoginResult) in
                self.loginAPIService.login(with: socialType, token: socialLogin.token)
            }
            .subscribe(onNext: { [weak self] apiResult in

                guard let result = apiResult
                else {
                    functionResult.onNext(LoginResult.loginFail)
                    return
                }

                switch result {
                case let LoginAPIResult.member(id, jwt, _):
                    self?.loginKeyChainService.setLoginInfo(loginType: .member, uuid: nil, userID: id, token: LoginToken(jwt: jwt))
                    functionResult.onNext(.member)
                case let LoginAPIResult.nonMember(uuid, _):
                    self?.loginKeyChainService.setLoginInfo(loginType: .nonMember, uuid: uuid, userID: nil, token: nil)
                    functionResult.onNext(.nonMember(uuid: uuid))
                case let LoginAPIResult.memberWaitCertification(_, jwt, _):
                    self?.loginKeyChainService.setLoginInfo(loginType: .waitCertification, uuid: nil, userID: nil, token: LoginToken(jwt: jwt))
                    functionResult.onNext(.memberWaitCertification)
                case let LoginAPIResult.stopped:
                    print("stopped")
                    self?.loginKeyChainService.setLoginInfo(loginType: .stopped, uuid: nil, userID: nil, token: nil)
                    functionResult.onNext(.stopped)
                }
            })
            .disposed(by: disposeBag)

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposeBag = DisposeBag()
            })
    }

    func logout() {
        DispatchQueue.main.async { [self] in
            self.naverLoginService.logout()
            self.kakaoLoginService.logout()
            self.loginKeyChainService.clear()
            self.userKeyChainService.clear()
        }
    }
}
