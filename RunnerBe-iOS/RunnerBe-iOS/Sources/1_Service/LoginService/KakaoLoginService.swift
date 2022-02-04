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
    init() {}

    let disposeBag = DisposeBag()

    func login() -> Observable<LoginData> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .do(onNext: nil, onError: { print($0) })
                .map {
                    print("loginWithKakaoTalk() success! \($0.accessToken)")
                    return LoginData(token: $0.accessToken)
                }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .do(onNext: nil, onError: { print($0) })
                .map {
                    print("loginWithKakaoAccount() success! \($0.accessToken)")
                    return LoginData(token: $0.accessToken)
                }
        }
    }
}
