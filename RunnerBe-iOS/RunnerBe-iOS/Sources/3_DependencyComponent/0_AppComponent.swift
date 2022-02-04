//
//  0_AppComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import NeedleFoundation

final class AppComponent: BootstrapComponent {
    override init() {
        super.init()
        _ = kakaoOAuthService
    }

    var kakaoOAuthService: KakaoOAuthService {
        return shared { KakaoOAuthService() }
    }

    var loggedOutComponent: LoggedOutComponent {
        return LoggedOutComponent(parent: self)
    }
}
