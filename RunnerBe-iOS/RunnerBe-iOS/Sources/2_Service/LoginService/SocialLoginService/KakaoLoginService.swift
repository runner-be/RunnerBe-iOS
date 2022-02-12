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

    func login() -> Observable<SocialLoginResult> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return loginWithKakaoApp()
        } else {
            return loginWithKakaoAccount()
        }
    }

    // MARK: Private

    private func loginWithKakaoApp() -> Observable<SocialLoginResult> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .map {
                return SocialLoginResult(token: $0.accessToken, loginType: .kakao)
            }
    }

    private func loginWithKakaoAccount() -> Observable<SocialLoginResult> {
        return UserApi.shared.rx.loginWithKakaoAccount()
            .do(onNext: nil, onError: { print($0) })
            .map {
                return SocialLoginResult(token: $0.accessToken, loginType: .kakao)
            }
    }
}
