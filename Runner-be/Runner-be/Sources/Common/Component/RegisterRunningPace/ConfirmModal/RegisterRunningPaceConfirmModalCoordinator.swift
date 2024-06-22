//
//  RegisterRunningPaceConfirmModalCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2/16/24.
//

import Foundation
import RxSwift

enum RegisterRunningPaceConfirmModalResult {
    case ok
    case close
}

final class RegisterRunningPaceConfirmModalCoordinator: BasicCoordinator<RegisterRunningPaceConfirmModalResult> {
    var component: RegisterRunningPaceConfirmModalComponent

    init(component: RegisterRunningPaceConfirmModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool = false) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: false)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.ok
            .map { RegisterRunningPaceConfirmModalResult.ok }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
