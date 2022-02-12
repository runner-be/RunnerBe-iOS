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
}

final class PolicyTermCoordinator: BasicCoordinator<PolicyTermResult> {
    // MARK: Lifecycle

    init(component: PolicyTermComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: PolicyTermComponent

    override func start() {
        let scene = component.scene

        navController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navController.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.nextProcess
            .subscribe(onNext: { [weak self] in
                self?.pushBirthCoord()
            })
            .disposed(by: disposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { PolicyTermResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.showPolicy
            .subscribe(onNext: { [weak self] policyType in
                self?.presentPolicyDetail(type: policyType)
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushBirthCoord() {
        let comp = component.birthComponent
        let coord = BirthCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .backward: break
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    private func presentPolicyDetail(type: PolicyType) {
        let comp = component.policyDetailComponent
        comp.policyType = type
        let coord = PolicyDetailCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .subscribe(onNext: { [weak self] _ in
                self?.release(coordinator: coord)
            })
        addChildBag(id: coord.id, disposable: disposable)
    }

    private func presentOnboardingCancelCoord() {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .debug("PolicyTerm - close Onboarding")
            .subscribe(onNext: { [weak self] modalResult in
                defer { self?.release(coordinator: coord) }
                switch modalResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })
        addChildBag(id: coord.id, disposable: disposable)
    }
}
