//
//  KakaoOAuthService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser

import RxSwift

final class KakaoLoginService: SocialLoginService {
    // MARK: Internal

    func login() -> Observable<SocialLoginResult?> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return loginWithKakaoApp()
        } else {
            return loginWithKakaoAccount()
        }
    }

    func logout() {
        UserApi.shared.logout(completion: { _ in })
    }

    // MARK: Private

    private func loginWithKakaoApp() -> Observable<SocialLoginResult?> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .catchAndReturn(OAuthToken())
            .map {
                $0.accessToken.isEmpty ? nil : SocialLoginResult(token: $0.accessToken, loginType: .kakao)
            }
    }

    private func loginWithKakaoAccount() -> Observable<SocialLoginResult?> {
        return UserApi.shared.rx.loginWithKakaoAccount()
            .catchAndReturn(OAuthToken())
            .map {
                $0.accessToken.isEmpty ? nil : SocialLoginResult(token: $0.accessToken, loginType: .kakao)
            }
    }
}

private extension OAuthToken {
    init() {
        self.init(accessToken: "", expiresIn: nil, expiredAt: nil, tokenType: "", refreshToken: "", refreshTokenExpiresIn: nil, refreshTokenExpiredAt: nil, scope: nil, scopes: nil)
    }
}
