//
//  OnboardingCompletionCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum OnboardingCompletionResult {
    case toMain
}

final class OnboardingCompletionCoordinator: BasicCoordinator<OnboardingCompletionResult> {
    var component: OnboardingCompletionComponent

    init(component: OnboardingCompletionComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                #if DEBUG
                    print("[WaitCertificationCoordinator][closeSignal] popViewController")
                #endif
                switch result {
                case .toMain:
                    self?.navigationController.popViewController(animated: false)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.toMain
            .map { OnboardingCompletionResult.toMain }
            .subscribe(closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
