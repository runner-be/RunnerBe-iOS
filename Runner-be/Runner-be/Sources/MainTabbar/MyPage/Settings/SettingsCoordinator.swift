//
//  SettingsCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxSwift

enum SettingsResult {
    case backward
    case logout
}

final class SettingsCoordinator: BasicCoordinator<SettingsResult> {
    var component: SettingsComponent

    init(component: SettingsComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .logout:
                    self?.navigationController.popViewController(animated: false)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { SettingsResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.makers
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushMakerScene(vm: vm, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.logout
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentLogoutModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.privacy
            .map { (vm: scene.VM, type: PolicyType.privacy_deal) }
            .subscribe(onNext: { [weak self] input in
                self?.pushPolicy(vm: input.vm, policyType: input.type, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.terms
            .map { (vm: scene.VM, type: PolicyType.service) }
            .subscribe(onNext: { [weak self] input in
                self?.pushPolicy(vm: input.vm, policyType: input.type, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.license
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushLicenseScene(vm: vm, animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.signout
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentSignoutModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.signoutComplete
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.presentSignoutCompletionModal(vm: vm, animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.logoutComplete
            .map { SettingsResult.logout }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }

    private func pushLicenseScene(vm _: SettingsViewModel, animated _: Bool) {
//        let comp = component.licenseComponent
//        let coord = LicenseCoordinator(component: comp, navController: navigationController)
//
//        let disposable = coordinate(coordinator: coord, animated: animated)
//            .subscribe(onNext: { [weak self] coordResult in
//                defer { self?.releaseChild(coordinator: coord) }
//                switch coordResult {
//                case .backward:
//                    break
//                }
//            })
//
//        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func pushMakerScene(vm _: SettingsViewModel, animated: Bool) {
        let comp = component.makerComponent
        let coord = MakerCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .backward:
                    break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentLogoutModal(vm: SettingsViewModel, animated: Bool) {
        let comp = component.logoutModalComponent
        let coord = LogoutModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .backward:
                    vm.routeInputs.logout.onNext(false)
                case .logout:
                    vm.routeInputs.logout.onNext(true)
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentSignoutModal(vm: SettingsViewModel, animated: Bool) {
        let comp = component.signoutModalComponent
        let coord = SignoutModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .signout:
                    vm.routeInputs.signout.onNext(true)
                case .cancel:
                    break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentSignoutCompletionModal(vm _: SettingsViewModel, animated: Bool) {
        let comp = component.signoutCompletionModalComponent
        let coord = SignoutCompletionModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .toLoginPage:
                    self?.closeSignal.onNext(.logout)
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func pushPolicy(vm _: SettingsViewModel, policyType: PolicyType, animated: Bool) {
        let comp = component.policyDetailComponent(type: policyType, modal: false)
        let coord = PolicyDetailCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] _ in
                self?.releaseChild(coordinator: coord)
            })
        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
