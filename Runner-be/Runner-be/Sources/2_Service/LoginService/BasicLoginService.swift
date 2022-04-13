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
    private let kakaoLoginService: SocialLoginService
    private let naverLoginService: SocialLoginService
    private let loginAPIService: LoginAPIService

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        loginAPIService: LoginAPIService = BasicLoginAPIService(),
        kakaoLoginService: SocialLoginService = KakaoLoginService(),
        naverLoginService: SocialLoginService = NaverLoginService()
    ) {
        self.kakaoLoginService = kakaoLoginService
        self.naverLoginService = naverLoginService
        self.loginAPIService = loginAPIService
        self.loginKeyChainService = loginKeyChainService
    }

    func checkLogin() -> Observable<CheckLoginResult> {
        guard let token = loginKeyChainService.token
        else { return .just(.nonMember) }

        return loginAPIService.login(with: token)
            .map { result in
                switch result {
                case .member:
                    return .member
                case .nonMember:
                    return .nonMember
                case .waitCertification:
                    return .memberWaitCertification
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
                    self?.loginKeyChainService.token = LoginToken(jwt: jwt)
                    self?.loginKeyChainService.userId = id
                    self?.loginKeyChainService.loginType = .member
                    functionResult.onNext(.member)
                case let LoginAPIResult.nonMember(uuid, _):
                    self?.loginKeyChainService.uuid = uuid
                    self?.loginKeyChainService.loginType = .nonMember
                    functionResult.onNext(.nonMember(uuid: uuid))
                case let LoginAPIResult.memberWaitCertification(_, jwt, _):
                    self?.loginKeyChainService.token = LoginToken(jwt: jwt)
                    self?.loginKeyChainService.loginType = .waitCertification
                    functionResult.onNext(.memberWaitCertification)
                }
            })
            .disposed(by: disposeBag)

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposeBag = DisposeBag()
            })
    }
}
