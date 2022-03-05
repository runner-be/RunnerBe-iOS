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
        scene.VC.setColors(
            iconNormal: UIColor.darkG35,
            selected: UIColor.primary
        )

        scene.VC.viewControllers = [
            configureAndGetHomeScene(vm: scene.VM),
            configureAndGetBookMarkScene(vm: scene.VM),
            configureAndGetMyPageScene(vm: scene.VM),
        ]

        navController.pushViewController(scene.VC, animated: false)

        closeSignal.subscribe(onNext: { [weak self] _ in
            self?.navController.popViewController(animated: false)
        })
        .disposed(by: disposeBag)

        scene.VM.routes.onboardingCover
            .debug()
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentOnboaradingCover(vm: vm, animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.waitOnboardingCover
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentWaitOnboaradingCover(vm: vm, animated: false)
            })
            .disposed(by: disposeBag)
    }

    private func configureAndGetHomeScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.homeComponent
        let coord = HomeCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: false)
            .subscribe(onNext: { coordResult in
                switch coordResult {
                case .needCover:
                    vm.routeInputs.needCover.onNext(())
                }
            })

        addChildBag(id: coord.id, disposable: disposable)

        vm.routes.home
            .subscribe(onNext: {
                comp.viewModel.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: disposeBag)

        return comp.scene.VC
    }

    private func configureAndGetBookMarkScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.bookmarkComponent
        let coord = BookMarkCoordinator(component: comp, navController: navController)

        coordinate(coordinator: coord, animated: false)

        vm.routes.bookmark
            .subscribe(onNext: {
                comp.scene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: disposeBag)

        return comp.scene.VC
    }

    private func configureAndGetMyPageScene(vm: MainTabViewModel) -> UIViewController {
        let comp = component.myPageComponent
        let coord = MyPageCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: false)
            .subscribe(onNext: { [weak self] coordResult in
                switch coordResult {
                case .logout:
                    self?.closeSignal.onNext(MainTabbarResult.logout)
                    self?.release()
                case .toMain:
                    vm.routeInputs.toHome.onNext(())
                }
            })

        vm.routes.myPage
            .subscribe(onNext: {
                comp.scene.VM.routeInputs.needUpdate.onNext(true)
            })
            .disposed(by: disposeBag)

        addChildBag(id: coord.id, disposable: disposable)
        return comp.scene.VC
    }

    private func presentOnboaradingCover(vm: MainTabViewModel, animated: Bool) {
        let comp = component.onboardingCoverComponent
        let coord = OnboardingCoverCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .toMain:
                    vm.routeInputs.onboardingCoverClosed.onNext(())
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func presentWaitOnboaradingCover(vm _: MainTabViewModel, animated: Bool) {
        let comp = component.onboardingWaitCoverComponent
        let coord = WaitOnboardingCoverCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] _ in
                defer { self?.release(coordinator: coord) }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childs["OnboardingCoverCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                presentOnboaradingCover(vm: component.scene.VM, animated: false)
                childs["OnboardingCoverCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
