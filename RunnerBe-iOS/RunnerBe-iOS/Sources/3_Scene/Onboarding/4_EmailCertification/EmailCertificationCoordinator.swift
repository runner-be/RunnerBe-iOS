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
        let emailCertification = component.scene
        navController.pushViewController(emailCertification.VC, animated: true)

        navController.rx.didShow
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.presentInitModal()
            })
            .disposed(by: disposeBag)

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

        emailCertification.VM.routes.photoCertification
            .subscribe(onNext: { [weak self] in
                self?.pushPhotoCertificationCoord()
            })
            .disposed(by: disposeBag)

        emailCertification.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord()
            })
            .disposed(by: disposeBag)

        emailCertification.VM.routes.backward
            .map { EmailCertificationResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    private func pushPhotoCertificationCoord() {
        let comp = component.photoCertificationComponent
        let coord = PhotoCertificationCoordinator(component: comp, navController: navController)
        let uuid = coord.id

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

        addChildBag(id: uuid, disposable: disposable)
    }

    private func presentOnboardingCancelCoord() {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navController)
        let uuid = coord.id

        let disposable = coordinate(coordinator: coord)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })

        addChildBag(id: uuid, disposable: disposable)
    }

    private func presentInitModal() {
        let comp = component.initModalComponent
        let coord = EmailCertificationInitModalCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.release(coordinator: coord)
            })

        addChildBag(id: id, disposable: disposable)
    }
}
