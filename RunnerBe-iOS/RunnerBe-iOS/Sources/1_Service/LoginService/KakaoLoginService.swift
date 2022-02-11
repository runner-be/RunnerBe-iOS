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

class KakaoLoginService: LoginServiceable {
    // MARK: Internal

    func login() -> Observable<OAuthLoginResult> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return loginWithKakaoApp()
        } else {
            return loginWithKakaoAccount()
        }
    }

    // MARK: Private

    private func loginWithKakaoApp() -> Observable<OAuthLoginResult> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .map {
                return OAuthLoginResult(token: $0.accessToken, loginType: .kakao)
            }
    }

    private func loginWithKakaoAccount() -> Observable<OAuthLoginResult> {
        return UserApi.shared.rx.loginWithKakaoAccount()
            .do(onNext: nil, onError: { print($0) })
            .map {
                return OAuthLoginResult(token: $0.accessToken, loginType: .kakao)
            }
    }
}
