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

    override func start(animated _: Bool = true) {}

    func showMain(certificated _: Bool, animated: Bool) {
        let mainTabbarCoord = MainTabbarCoordinator(component: component.mainTabComponent, navController: navController)

        coordinate(coordinator: mainTabbarCoord, animated: animated)
    }

    func showLoggedOut(animated: Bool) {
        let comp = component.loggedOutComponent
        let coord = LoggedOutCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }

                switch coordResult {
                case let .loginSuccess(certificated):
                    self?.showMain(certificated: certificated, animated: false)
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childs["LoggedOutCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                showLoggedOut(animated: false)
                childs["LoggedOutCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
