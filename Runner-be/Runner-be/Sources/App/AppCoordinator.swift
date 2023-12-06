//
//  AppCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxSwift
import UIKit

final class AppCoordinator: BasicCoordinator<Void> {
    var window: UIWindow

    // MARK: Lifecycle

    init(component: AppComponent, window: UIWindow) {
        self.component = component
        self.window = window
        let navController = UINavigationController()
        window.rootViewController = navController
        AppContext.shared.rootNavigationController = navController
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: AppComponent

    override func start(animated _: Bool = true) {
        BasicLoginKeyChainService.shared.clearIfFirstLaunched()
        window.makeKeyAndVisible()

        component.loginService.checkLogin()
            .subscribe(onNext: { result in
                switch result {
                case .member:
                    self.showMain(animated: false)
                case .memberWaitCertification:
                    self.showMain(animated: false)
                case .nonMember:
                    self.showLoggedOut(animated: false)
                case .stopped:
                    self.showLoggedOut(animated: false)
                }
            })
            .disposed(by: sceneDisposeBag)
    }

    func showMain(animated: Bool) {
        let comp = component.mainTabComponent
        let coord = MainTabbarCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .logout:
                self?.showLoggedOut(animated: false)
            }
        }
    }

    func showLoggedOut(animated: Bool) {
        let comp = component.loggedOutComponent
        let coord = LoggedOutCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .loginSuccess:
                self?.showMain(animated: false)
            }
        }
    }
}
