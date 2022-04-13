//
//  WaitOnboardingCoverCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/05.
//

import Foundation
import RxSwift

enum WaitOnboardingCoverResult {
    case toMain
}

final class WaitOnboardingCoverCoordinator: BasicCoordinator<OnboardingCoverResult> {
    var component: WaitOnboardingCoverComponent

    init(component: WaitOnboardingCoverComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.toMain
            .map { OnboardingCoverResult.toMain }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
