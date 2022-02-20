//
//  3__2_MessageCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol MessageListResult {}

final class MessageListCoordinator: TabCoordinator<MessageListResult> {
    // MARK: Lifecycle

    init(component: MessageListComponent, tabController: UITabBarController, navController: UINavigationController) {
        self.component = component
        super.init(tabController: tabController, navController: navController)
    }

    // MARK: Internal

    var component: MessageListComponent

    override func start(animated _: Bool = true) {}
}
