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

final class MainTabbarCoordinator: TabCoordinator<MainTabbarResult> {
    // MARK: Lifecycle

    init(component: MainTabComponent, navController: UINavigationController) {
        self.component = component
        super.init(tabController: component.scene, navController: navController)
    }

    // MARK: Internal

    var component: MainTabComponent

    override func start(animated _: Bool = true) {
        startTabbarController()
    }

    // MARK: Private

    private func startTabbarController() {
        UITabBar.appearance().backgroundColor = UIColor.darkG6
        tabController.setColors(
            iconNormal: UIColor.darkG35,
            selected: UIColor.primary
        )

        tabController.viewControllers = [
            configureAndGetHomeScene(),
            configureAndGetBookMarkScene(),
            configureAndGetMyPageScene(),
        ]

        navController.pushViewController(tabController, animated: false)
    }

    private func configureAndGetHomeScene() -> UIViewController {
        let comp = component.homeComponent
        let coord = HomeCoordinator(component: comp, tabController: tabController, navController: navController)

        coordinate(coordinator: coord, animated: false)

        return comp.scene.VC
    }

    private func configureAndGetBookMarkScene() -> UIViewController {
        let comp = component.bookmarkComponent
        let coord = BookMarkCoordinator(component: comp, tabController: tabController, navController: navController)

        coordinate(coordinator: coord, animated: false)

        return comp.scene.VC
    }

    private func configureAndGetMyPageScene() -> UIViewController {
        let comp = component.myPageComponent
        let coord = MyPageCoordinator(component: comp, tabController: tabController, navController: navController)

        coordinate(coordinator: coord, animated: false)

        return comp.scene.VC
    }
}
