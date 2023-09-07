//
//  0_AppComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import UIKit

final class AppComponent {
    var loginComponent: LoginComponent {
        return LoginComponent()
    }

    var mainTabComponent: MainTabComponent {
        return MainTabComponent()
    }

    var loginService = BasicLoginService()
}
