//
//  RegisterRunningPaceCancelModalCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 4/16/24.
//

import UIKit

enum RegisterRunningPaceCancelResult {
    case cancel
    case ok
}

final class RegisterRunningPaceCancelModalCoordinator: BasicCoordinator<RegisterRunningPaceCancelResult> {
    var component: RegisterRunningPaceCancelModalComponent

    init(component: RegisterRunningPaceCancelModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = false) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.backward
            .debug()
            .map { RegisterRunningPaceCancelResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.ok
            .debug()
            .map { RegisterRunningPaceCancelResult.ok }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
