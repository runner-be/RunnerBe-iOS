//
//  NaverLoginService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NaverThirdPartyLogin
import RxSwift

final class NaverLoginService: NSObject, SocialLoginService {
    // MARK: Lifecycle

    override init() {
        loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        super.init()
        loginConnection.delegate = self
    }

    // MARK: Internal

    var loginDataStream = PublishSubject<SocialLoginResult?>()

    func login() -> Observable<SocialLoginResult?> {
        loginConnection.requestThirdPartyLogin()
        return loginDataStream
    }

    func logout() {
        loginConnection.requestDeleteToken()
    }

    // MARK: Private

    private var loginConnection: NaverThirdPartyLoginConnection
}

extension NaverLoginService: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 성고시 호출됨
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        loginDataStream.onNext(SocialLoginResult(
            token: loginConnection.accessToken,
            loginType: .naver
        )
        )
    }

    // refresh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginDataStream.onNext(SocialLoginResult(
            token: loginConnection.accessToken,
            loginType: .naver
        )
        )
    }

    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {}

    // 모든 에러
    func oauth20Connection(_: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        loginDataStream.onNext(nil)
    }
}
