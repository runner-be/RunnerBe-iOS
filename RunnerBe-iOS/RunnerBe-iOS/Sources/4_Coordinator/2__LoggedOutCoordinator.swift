//
//  2__LoggedOutCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

enum LoggedOutResult {}

final class LoggedOutCoordinator: BasicCoordinator<LoggedOutResult> {
    var component: LoggedOutComponent

    init(component: LoggedOutComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        navController.pushViewController(component.loggedOutViewController, animated: false)
    }
}
