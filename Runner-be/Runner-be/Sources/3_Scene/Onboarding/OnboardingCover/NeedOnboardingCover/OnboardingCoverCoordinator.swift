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
        navController.present(newNavController, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.newNavController.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.lookMain
            .map { OnboardingCoverResult.toMain }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.goOnboard
            .map { scene.VM }
            .subscribe(onNext: { [weak self] _ in
                self?.pushPolicyTerm(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.testCertificated
            .map { OnboardingCoverResult.toMain }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }

    private func pushPolicyTerm(animated: Bool) {
        let comp = component.policyTermComponent
        let coord = PolicyTermCoordinator(component: comp, navController: newNavController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer { self?.release(coordinator: coord) }
                switch coordResult {
                case .toMain:
                    self?.closeSignal.onNext(.toMain)
                case .backward, .cancelOnboarding:
                    break
                }
            })

        addChildBag(id: coord.id, disposable: disposable)
    }

    override func handleDeepLink(type: DeepLinkType) {
        switch type {
        case .emailCertification:
            if let coord = childs["PolicyTermCoordinator"] {
                coord.handleDeepLink(type: type)
            } else {
                pushPolicyTerm(animated: false)
                childs["PolicyTermCoordinator"]!.handleDeepLink(type: type)
            }
        }
    }
}
