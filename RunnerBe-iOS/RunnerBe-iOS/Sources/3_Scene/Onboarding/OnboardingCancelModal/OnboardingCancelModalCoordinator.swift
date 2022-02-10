//
//  OnboardingCancelModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum OnboardingCancelModalResult {
    case cancelModal
    case cancelOnboarding
}

final class OnboardingCancelModalCoordinator: BasicCoordinator<OnboardingCancelModalResult> {
    var component: OnboardingCancelModalComponent

    init(component: OnboardingCancelModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        let viewController = component.onboardingCancelModalViewController
        viewController.modalPresentationStyle = .overCurrentContext
        navController.present(viewController, animated: false)

        closeSignal
            .subscribe(onNext: { _ in
                viewController.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        component.onboardingCancelModalViewModel
            .routes.backward
            .map { OnboardingCancelModalResult.cancelModal }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        component.onboardingCancelModalViewModel
            .routes.cancel
            .map { OnboardingCancelModalResult.cancelOnboarding }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
