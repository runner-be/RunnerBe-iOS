//
//  BasicLoginService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

final class BasicLoginService: LoginService {
    private var loginKeyChainService: LoginKeyChainService
    private let kakaoLoginService: SocialLoginService
    private let naverLoginService: SocialLoginService
    private let loginAPIService: LoginAPIService

    init(
        loginKeyChainService: LoginKeyChainService,
        loginAPIService: LoginAPIService,
        kakaoLoginService: SocialLoginService,
        naverLoginService: SocialLoginService
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
        let socialLoginResult: Observable<SocialLoginResult>
        switch socialType {
        case .naver:
            socialLoginResult = naverLoginService.login()
        case .kakao:
            socialLoginResult = kakaoLoginService.login()
        case .apple:
            socialLoginResult = .just(SocialLoginResult(token: "", loginType: socialType))
        }

        return socialLoginResult
            .map { [weak self] result in
                self?.loginAPIService.login(with: socialType, token: result.token)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .map { [weak self] apiResult -> LoginResult in
                guard let result = apiResult
                else { return LoginResult.loginFail }
                switch result {
                case let LoginAPIResult.member(id, jwt, _):
                    self?.loginKeyChainService.token = LoginToken(jwt: jwt)
                    self?.loginKeyChainService.userId = id
                    self?.loginKeyChainService.loginType = .member
                    return .member
                case let LoginAPIResult.nonMember(uuid, _):
                    self?.loginKeyChainService.uuid = uuid
                    self?.loginKeyChainService.loginType = .nonMember
                    return .nonMember(uuid: uuid)
                case let LoginAPIResult.memberWaitCertification(_, jwt, _):
                    self?.loginKeyChainService.token = LoginToken(jwt: jwt)
                    self?.loginKeyChainService.loginType = .waitCertification
                    return .memberWaitCertification
                }
            }
    }
}
