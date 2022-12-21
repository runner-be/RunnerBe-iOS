//
//  OnboardingCoverCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/04.
//

import Foundation
import RxSwift

enum OnboardingCoverResult {
    case toMain
}

final class OnboardingCoverCoordinator: BasicCoordinator<OnboardingCoverResult> {
    var component: OnboardingCoverComponent
    var newNavController: UINavigationController

    init(component: OnboardingCoverComponent, navController: UINavigationController) {
        self.component = component
        newNavController = UINavigationController()
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        newNavController.modalPresentationStyle = .overCurrentContext
        newNavController.pushViewController(scene.VC, animated: false)
        navigationController.present(newNavController, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.newNavController.dismiss(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.lookMain
            .map { OnboardingCoverResult.toMain }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.goOnboard
            .map { scene.VM }
            .subscribe(onNext: { [weak self] _ in
                self?.pushPolicyTerm(animated: true)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.testCertificated
            .map { OnboardingCoverResult.toMain }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }

    private func pushPolicyTerm(animated: Bool) {
        let comp = component.policyTermComponent
        let coord = PolicyTermCoordinator(component: comp, navController: newNavController)

        coordinate(coordinator: coord, animated: animated) { [weak self] coordResult in
            switch coordResult {
            case .toMain:
                self?.closeSignal.onNext(.toMain)
            case .backward, .cancelOnboarding:
                break
            }
        }
    }
}
