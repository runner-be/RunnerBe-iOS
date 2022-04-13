//
//  SignoutModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/06.
//

import Foundation
import RxSwift

enum SignoutModalResult {
    case signout
    case cancel
}

final class SignoutModalCoordinator: BasicCoordinator<SignoutModalResult> {
    var component: SignoutModalComponent

    init(component: SignoutModalComponent, navController: UINavigationController) {
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
            .routes.cancel
            .map { SignoutModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM
            .routes.signout
            .map { SignoutModalResult.signout }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
