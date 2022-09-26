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

final class MainTabbarCoordinator: BasicCoordinator<MainTabbarResult> {
    // MARK: Lifecycle

    init(component: MainTabComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: MainTabComponent

    override func start(animated _: Bool = true) {
        startTabbarController()
    }

    // MARK: Private

    private func startTabbarController() {
        let scene = component.scene
        UITabBar.appearance().backgroundColor = UIColor.darkG6

        scene.VC.viewControllers = [
            configureAndGetHomeScene(vm: scene.VM),
            configureAndGetBookMarkScene(vm: scene.VM),
            configureAndGetMessageScene(vm: scene.VM),
            configureAndGetMyPageScene(vm: scene.VM),
        ]

        navigationController.pushViewController(scene.VC, animated: false)

        closeSignal.subscribe(onNext: { [weak self] _ in
            self?.navigationController.popViewController(animated: false)
        })
        .disposed(by: sceneDisposeBag)

        scene.VM.routes.onboardingCover
            .debug()
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentOnboaradingCover(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func configureAndGetHomeScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.homeComponent
        let coord = HomeCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: false, needRelease: false) { coordResult in
            switch coordResult {
            case .needCover:
                vm.routeInputs.needCover.onNext(())
            }
        }

        vm.routes.home
            .subscribe(onNext: {
                comp.viewModel.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: sceneDisposeBag)

        return comp.scene.VC
    }

    private func configureAndGetBookMarkScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.bookmarkComponent
        let coord = BookMarkCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: false, needRelease: false)

        vm.routes.bookmark
            .subscribe(onNext: {
                comp.scene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: sceneDisposeBag)

        return comp.scene.VC
    }

    private func configureAndGetMessageScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.messageComponent
        let coord = MessageCoordinator(component: comp, navController: navigationController)

        vm.routes.message
            .subscribe(onNext: {
                comp.scene.VM.routeInputs.needsUpdate.onNext(true)
            })
            .disposed(by: sceneDisposeBag)

        coordinate(coordinator: coord, animated: false, needRelease: false)

        return comp.scene.VC
    }

    private func configureAndGetMyPageScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.myPageComponent
        let coord = MyPageCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: false, needRelease: false) { [weak self] coordResult in
            switch coordResult {
            case .logout:
                self?.closeSignal.onNext(MainTabbarResult.logout)
                self?.release()
            case .toMain:
                vm.routeInputs.toHome.onNext(())
            }
        }

        vm.routes.myPage
            .subscribe(onNext: {
                comp.scene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: sceneDisposeBag)

        return comp.scene.VC
    }

    private func presentOnboaradingCover(vm: MainTabViewModel, animated: Bool) {
        let comp = component.onboardingCoverComponent
        let coord = OnboardingCoverCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .toMain:
                vm.routeInputs.onboardingCoverClosed.onNext(())
            }
        }
    }
}
