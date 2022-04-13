//
//  PolicyTermCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import RxSwift

enum PolicyTermResult {
    case cancelOnboarding
    case backward
    case toMain
}

final class PolicyTermCoordinator: BasicCoordinator<PolicyTermResult> {
    // MARK: Lifecycle

    init(component: PolicyTermComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: PolicyTermComponent

    override func start(animated: Bool = true) {
        let scene = component.scene

        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[PolicyTermCoordinator][closeSignal] popViewController")
                #endif
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navigationController.popViewController(animated: true)
                case .toMain:
                    self?.navigationController.popViewController(animated: false)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.nextProcess
            .subscribe(onNext: { [weak self] in
                self?.pushBirthCoord(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { PolicyTermResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.showPolicy
            .subscribe(onNext: { [weak self] policyType in
                self?.presentPolicyDetail(type: policyType, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    // MARK: Private

    private func pushBirthCoord(animated: Bool) {
        let comp = component.birthComponent
        let coord = BirthCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .toMain:
                    self?.closeSignal.onNext(.toMain)
                case .backward: break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentPolicyDetail(type: PolicyType, animated: Bool) {
        let comp = component.policyDetailComponent(type: type, modal: true)
        let coord = PolicyDetailCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] _ in
                self?.releaseChild(coordinator: coord)
            })
        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    private func presentOnboardingCancelCoord(animated: Bool) {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .debug("PolicyTerm - close Onboarding")
            .subscribe(onNext: { [weak self] modalResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch modalResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })
        addChildDisposable(id: coord.identifier, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childCoordinators["BirthCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                pushBirthCoord(animated: false)
                childCoordinators["BirthCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
