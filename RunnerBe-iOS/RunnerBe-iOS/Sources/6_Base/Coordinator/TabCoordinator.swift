//
//  TabCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/15.
//

import Foundation
import UIKit

class TabCoordinator<ResultType>: BasicCoordinator<ResultType> {
    var tabController: UITabBarController

    init(tabController: UITabBarController, navController: UINavigationController) {
        self.tabController = tabController
        super.init(navController: navController)
    }
}
