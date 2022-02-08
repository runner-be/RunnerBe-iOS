//
//  3__MainTabbarCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift
import UIKit

enum MainTabbarResult {}

final class MainTabbarCoordinator: BasicCoordinator<MainTabbarResult> {
    // MARK: Lifecycle

    init(component: MainTabComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: MainTabComponent

    override func start() {
        startTabbarController()
    }

    // MARK: Private

    private func startTabbarController() {
        let tabbarCtrl = component.mainTabbarController

        UITabBar.appearance().backgroundColor = UIColor.darkG6
        tabbarCtrl.setColors(
            iconNormal: UIColor.darkG35,
            selected: UIColor.primary
        )

        let homeCoord = HomeCoordinator(component: component.homeComponent, navController: navController)
        let bookmarkCoord = BookMarkCoordinator(component: component.bookmarkComponent, navController: navController)
        let messageCoord = MessageCoordinator(component: component.messageComponent, navController: navController)
        let mypageCoord = MyPageCoordinator(component: component.myPageComponent, navController: navController)

        coordinate(coordinator: homeCoord)
        coordinate(coordinator: bookmarkCoord)
        coordinate(coordinator: messageCoord)
        coordinate(coordinator: mypageCoord)

        tabbarCtrl.viewControllers = [
            homeCoord.component.homeViewController,
            bookmarkCoord.component.bookMarkViewController,
            messageCoord.component.messageViewController,
            mypageCoord.component.myPageViewController,
        ]

        navController.pushViewController(tabbarCtrl, animated: false)
    }
}