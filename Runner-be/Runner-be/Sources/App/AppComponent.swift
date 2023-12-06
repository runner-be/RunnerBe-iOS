//
//  AppComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import UIKit

final class AppComponent {
    var loggedOutComponent: LoggedOutComponent {
        return LoggedOutComponent()
    }

    var mainTabComponent: MainTabComponent {
        return MainTabComponent()
    }

    var loginService = BasicLoginService()
}
