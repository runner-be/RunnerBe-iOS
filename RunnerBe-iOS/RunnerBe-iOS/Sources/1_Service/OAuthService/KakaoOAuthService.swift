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

class KakaoOAuthService: KakaoOAuthServicable {
    init() {}

    let disposeBag = DisposeBag()
    func login() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { _, error in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success")
                }
            }
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { _ in
                    print("loginWithKakaoAccount() success")
                })
                .disposed(by: disposeBag)
        }
    }
}
