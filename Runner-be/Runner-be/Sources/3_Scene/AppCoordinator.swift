//
//  1_AppCoordinator.swift
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
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: AppComponent

    override func start(animated _: Bool = true) {
        BasicLoginKeyChainService.shared.token = nil
        window.makeKeyAndVisible()

        BasicLoginService().checkLogin()
            .subscribe(onNext: { result in
                switch result {
                case .member:
                    self.showMain(animated: false)
                case .memberWaitCertification:
                    self.showMain(animated: false)
                case .nonMember:
                    self.showLoggedOut(animated: false)
                }
            })
            .disposed(by: disposeBag)
    }

    func showMain(animated: Bool) {
        let comp = component.mainTabComponent
        let coord = MainTabbarCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .logout:
                    self?.showLoggedOut(animated: false)
                }
            })

        addChildBag(id: coord.identifier, disposable: disposable)
    }

    func showLoggedOut(animated: Bool) {
        let comp = component.loggedOutComponent
        let coord = LoggedOutCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }

                switch coordResult {
                case .loginSuccess:
                    self?.showMain(animated: false)
                }
            })

        addChildBag(id: coord.identifier, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childCoordinators["MainTabbarCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                showMain(animated: false)
                childCoordinators["MainTabbarCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
