//
//  3__MainTabbarCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift
import UIKit

protocol MainTabbarResult {}

final class MainTabbarCoordinator: BasicCoordinator<MainTabbarResult> {
    var component: MainTabComponent

    init(component: MainTabComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        startTabbarController()
    }

    private func startTabbarController() {
        let tabbarCtrl = component.mainTabbarController

        UITabBar.appearance().backgroundColor = Asset.Colors.tabbarBg.uiColor
        tabbarCtrl.setColors(
            iconNormal: Asset.Colors.tabIconNormal.uiColor,
            selected: Asset.Colors.tabIconSelected.uiColor
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
