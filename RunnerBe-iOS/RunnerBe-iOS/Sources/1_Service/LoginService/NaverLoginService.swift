//
//  NaverOAuthService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NaverThirdPartyLogin
import RxSwift

final class NaverLoginService: NSObject, LoginServiceable {
    private var loginConnection: NaverThirdPartyLoginConnection
    var loginDataStream = PublishSubject<LoginData>()

    override init() {
        loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        super.init()
        loginConnection.delegate = self
    }

    func login() -> Observable<LoginData> {
        loginConnection.requestThirdPartyLogin()
        return loginDataStream
    }
}

extension NaverLoginService: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 성고시 호출됨
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("loginWithNaver() success! \(loginConnection.accessToken)")
        loginDataStream.onNext(LoginData(token: loginConnection.accessToken))
    }

    // refresh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {}

    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {}

    // 모든 에러
    func oauth20Connection(_: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        loginDataStream.onError(error)
    }
}
