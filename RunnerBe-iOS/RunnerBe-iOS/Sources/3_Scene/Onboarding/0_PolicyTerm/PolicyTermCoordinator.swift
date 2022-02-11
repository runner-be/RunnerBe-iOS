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
        let policyTerm = component.policyTerm

        navController.pushViewController(policyTerm.VC, animated: true)

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

        policyTerm.VM.routes.nextProcess
            .subscribe(onNext: { [weak self] in
                self?.pushBirthCoord()
            })
            .disposed(by: disposeBag)

        policyTerm.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        policyTerm.VM.routes.backward
            .map { PolicyTermResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushBirthCoord() {
        let birthComp = component.birthComponent

        let birthCoord = BirthCoordinator(component: birthComp, navController: navController)

        let disposable = coordinate(coordinator: birthCoord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: birthCoord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .backward: break
                }
            })

        childBags[birthCoord.uuid, default: []].append(disposable)
    }

    private func presentOnboardingCancelCoord() {
        let cancelModalComp = component.onboardingCancelModalComponent
        let cancelModalCoord = OnboardingCancelModalCoordinator(component: cancelModalComp, navController: navController)

        let disposable = coordinate(coordinator: cancelModalCoord)
            .debug("PolicyTerm - close Onboarding")
            .subscribe(onNext: { [weak self] modalResult in
                defer { self?.release(coordinator: cancelModalCoord) }
                switch modalResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })
        childBags[cancelModalCoord.uuid, default: []].append(disposable)
    }
}
