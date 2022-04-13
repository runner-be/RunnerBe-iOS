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

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM
            .routes.backward
            .map { OnboardingCancelModalResult.cancelModal }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM
            .routes.cancel
            .map { OnboardingCancelModalResult.cancelOnboarding }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
