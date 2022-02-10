//
//  EmailCertificationCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum EmailCertificationResult {
    case cancelOnboarding
    case backward
}

final class EmailCertificationCoordinator: BasicCoordinator<EmailCertificationResult> {
    // MARK: Lifecycle

    init(component: EmailCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: EmailCertificationComponent

    override func start() {
        let viewController = component.emailCertificationViewController
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

        component.emailCertificationViewModel
            .routes.photoCertification
            .subscribe(onNext: {
                self.pushPhotoCertificationCoord()
            })
            .disposed(by: disposeBag)

        component.emailCertificationViewModel
            .routes.cancel
            .subscribe(onNext: {
                self.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        component.emailCertificationViewModel
            .routes.backward
            .map { EmailCertificationResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    private func pushPhotoCertificationCoord() {
        let photoCertificationComp = component.photoCertificationComponent
        let photoCertificationCoord = PhotoCertificationCoordinator(component: photoCertificationComp, navController: navController)

        coordinate(coordinator: photoCertificationCoord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: photoCertificationCoord) }
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
