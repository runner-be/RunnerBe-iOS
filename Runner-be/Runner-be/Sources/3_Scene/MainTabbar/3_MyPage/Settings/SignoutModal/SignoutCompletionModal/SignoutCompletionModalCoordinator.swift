//
//  SignoutCompletionModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/06.
//

import Foundation
import RxSwift

enum SignoutCompletionModalResult {
    case toLoginPage
}

final class SignoutCompletionModalCoordinator: BasicCoordinator<SignoutCompletionModalResult> {
    var component: SignoutCompletionModalComponent

    init(component: SignoutCompletionModalComponent, navController: UINavigationController) {
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
            .routes.toLoginPage
            .map { SignoutCompletionModalResult.toLoginPage }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
