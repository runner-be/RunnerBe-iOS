//
//  3__2_MessageCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol MessageResult {}

final class MessageCoordinator: TabCoordinator<HomeResult> {
    // MARK: Lifecycle

    init(component: MessageComponent, tabController: UITabBarController, navController: UINavigationController) {
        self.component = component
        super.init(tabController: tabController, navController: navController)
    }

    // MARK: Internal

    var component: MessageComponent

    override func start() {}
}
