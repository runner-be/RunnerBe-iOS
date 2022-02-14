//
//  1_AppCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxSwift
import UIKit

final class AppCoordinator: BasicCoordinator<Void> {
    // MARK: Lifecycle

    init(component: AppComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: AppComponent

    override func start() {}

    func showMain(certificated _: Bool) {
        let mainTabbarCoord = MainTabbarCoordinator(component: component.mainTabComponent, navController: navController)

        coordinate(coordinator: mainTabbarCoord)
    }

    func showLoggedOut() {
        let comp = component.loggedOutComponent
        let coord = LoggedOutCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }

                switch coordResult {
                case let .loginSuccess(certificated):
                    self?.showMain(certificated: certificated)
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }
}
