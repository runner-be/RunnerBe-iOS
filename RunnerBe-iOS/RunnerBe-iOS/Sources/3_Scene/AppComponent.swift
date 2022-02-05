//
//  0_AppComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import NeedleFoundation

final class AppComponent: BootstrapComponent {
    // MARK: Lifecycle

    override init() {
        super.init()
        _ = kakaoLoginService
    }

    // MARK: Internal

    var kakaoLoginService: KakaoLoginService {
        return shared { KakaoLoginService() }
    }

    var naverLoginService: NaverLoginService {
        return shared { NaverLoginService() }
    }

    var loggedOutComponent: LoggedOutComponent {
        return LoggedOutComponent(parent: self)
    }

    var mainTabComponent: MainTabComponent {
        return MainTabComponent(parent: self)
    }
}
