//
//  1_AppCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxSwift
import UIKit

final class AppCoordinator: BasicCoordinator<Void> {
    var component: AppComponent

    init(component: AppComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {}

    func showMain() {
        let mainTabbarCoord = MainTabbarCoordinator(component: component.mainTabComponent, navController: navController)

        coordinate(coordinator: mainTabbarCoord)
    }

    func showLoggedOut() {
        let loggedOutCoord = LoggedOutCoordinator(component: component.loggedOutComponent, navController: navController)
        coordinate(coordinator: loggedOutCoord)
    }
}
