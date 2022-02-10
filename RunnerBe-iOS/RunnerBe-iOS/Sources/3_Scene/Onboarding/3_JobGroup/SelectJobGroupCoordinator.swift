//
//  SelectJobGroupCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum SelectJobGroupResult {
    case cancelOnboarding
    case backward
}

final class SelectJobGroupCoordinator: BasicCoordinator<SelectJobGroupResult> {
    // MARK: Lifecycle

    init(component: SelectJobGroupComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SelectJobGroupComponent

    override func start() {
        let viewController = component.selectJobGroupViewController
        navController.pushViewController(viewController, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navController.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)

        component.selectJobGroupViewModel.routes.nextProcess
            .subscribe(onNext: {
                self.pushEmailCertificationCoord()
            })
            .disposed(by: disposeBag)

        component.selectJobGroupViewModel.routes.cancel
            .subscribe(onNext: {
                self.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        component.selectJobGroupViewModel.routes.backward
            .map { SelectJobGroupResult.backward }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushEmailCertificationCoord() {
        let emailCertificationComp = component.emailCertificationComponent

        let emailCertificationCoord = EmailCertificationCoordinator(component: emailCertificationComp, navController: navController)

        coordinate(coordinator: emailCertificationCoord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: emailCertificationCoord) }
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
            .subscribe(onNext: { coordResult in
                defer { self.release(coordinator: cancelModalCoord) }
                switch coordResult {
                case .cancelOnboarding:
                    self.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
