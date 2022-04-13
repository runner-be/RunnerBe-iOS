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
    case toMain
}

final class EmailCertificationCoordinator: BasicCoordinator<EmailCertificationResult> {
    // MARK: Lifecycle

    init(component: EmailCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: EmailCertificationComponent

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        navigationController.rx.didShow
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.presentInitModal(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[EmailCertificationCoordinator][closeSignal] popViewController")
                #endif
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                case .cancelOnboarding:
                    self?.navigationController.popViewController(animated: false)
                case .toMain:
                    self?.navigationController.popViewController(animated: false)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.toIDCardCertification
            .subscribe(onNext: { [weak self] in
                self?.pushPhotoCertificationCoord(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCancelCoord(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { EmailCertificationResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.signupComplete
            .subscribe(onNext: { [weak self] in
                self?.presentOnboardingCompletionCoord(animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    private func pushPhotoCertificationCoord(animated: Bool) {
        let comp = component.idCardCertificationComponent
        let coord = PhotoCertificationCoordinator(component: comp, navController: navigationController)
        let uuid = coord.identifier

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

        addChildDisposable(id: uuid, disposable: disposable)
    }

    private func presentOnboardingCancelCoord(animated: Bool) {
        let comp = component.onboardingCancelModalComponent
        let coord = OnboardingCancelModalCoordinator(component: comp, navController: navigationController)
        let uuid = coord.identifier

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .cancelOnboarding:
                    self?.closeSignal.onNext(.cancelOnboarding)
                case .cancelModal:
                    break
                }
            })

        addChildDisposable(id: uuid, disposable: disposable)
    }

    private func presentOnboardingCompletionCoord(animated: Bool) {
        let comp = component.onboardingCompletionComponent
        let coord = OnboardingCompletionCoordinator(component: comp, navController: navigationController)
        let uuid = coord.identifier

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .toMain:
                    self?.closeSignal.onNext(.toMain)
                }
            })

        addChildDisposable(id: uuid, disposable: disposable)
    }

    private func presentInitModal(animated: Bool) {
        let comp = component.initModalComponent
        let coord = EmailCertificationInitModalCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.releaseChild(coordinator: coord)
            })

        addChildDisposable(id: identifier, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case let .emailCertification(hashedUUID, email):
            if BasicSignupKeyChainService.shared.uuid.sha256 == hashedUUID {
                component.scene.VM.routeInputs.emailCertifated.onNext(email)
            }
        }
    }
}
