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
        let viewController = component.policyTermViewController
        navController.pushViewController(viewController, animated: true)

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

        component.policyTermViewModel.routes.nextProcess
            .subscribe(onNext: {
                self.pushBirthCoord()
            })
            .disposed(by: disposeBag)

        component.policyTermViewModel.routes.cancel
            .subscribe(onNext: {
                self.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        component.policyTermViewModel.routes.backward
            .map { PolicyTermResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushBirthCoord() {
        let birthComp = component.birthComponent

        let birthCoord = BirthCoordinator(component: birthComp, navController: navController)

        coordinate(coordinator: birthCoord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: birthCoord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .backward: break
                }
            })
            .disposed(by: disposeBag)
    }

    private func presentOnboardingCancelCoord() {
        let cancelModalComp = component.onboardingCancelModalComponent
        let cancelModalCoord = OnboardingCancelModalCoordinator(component: cancelModalComp, navController: navController)

        coordinate(coordinator: cancelModalCoord)
            .take(1)
            .debug("PolicyTerm - close Onboarding")
            .subscribe(onNext: { modalResult in
                defer { self.release(coordinator: cancelModalCoord) }
                switch modalResult {
                case .cancelOnboarding:
                    self.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
