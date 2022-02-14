//
//  3__3_MyPageCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol MyPageResult {}

final class MyPageCoordinator: TabCoordinator<HomeResult> {
    // MARK: Lifecycle

    init(component: MyPageComponent, tabController: UITabBarController, navController: UINavigationController) {
        self.component = component
        super.init(tabController: tabController, navController: navController)
    }

    // MARK: Internal

    var component: MyPageComponent

    override func start() {}
}
