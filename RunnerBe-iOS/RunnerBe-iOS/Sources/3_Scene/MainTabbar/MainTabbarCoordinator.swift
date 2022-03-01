//
//  3__MainTabbarCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift
import UIKit

enum MainTabbarResult {
    case logout
}

final class MainTabbarCoordinator: TabCoordinator<MainTabbarResult> {
    // MARK: Lifecycle

    init(component: MainTabComponent, navController: UINavigationController) {
        self.component = component
        super.init(tabController: component.sharedScene.VC, navController: navController)
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

        component.sharedScene.VM.routes.home
            .subscribe(onNext: {
                comp.sharedScene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: disposeBag)

        return comp.sharedScene.VC
    }

    private func configureAndGetBookMarkScene() -> UIViewController {
        let comp = component.bookmarkComponent
        let coord = BookMarkCoordinator(component: comp, tabController: tabController, navController: navController)

        coordinate(coordinator: coord, animated: false)

        component.sharedScene.VM.routes.bookmark
            .subscribe(onNext: {
                comp.sharedScene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: disposeBag)

        return comp.sharedScene.VC
    }

    private func configureAndGetMyPageScene() -> UIViewController {
        let comp = component.myPageComponent
        let coord = MyPageCoordinator(component: comp, tabController: tabController, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: false)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .logout:
                    self?.closeSignal.onNext(MainTabbarResult.logout)
                }
            })

        component.sharedScene.VM.routes.myPage
            .subscribe(onNext: {
                comp.sharedScene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: disposeBag)

        addChildBag(id: coord.id, disposable: disposable)
        return comp.sharedScene.VC
    }
}
