//
//  ConfirmModalCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2/16/24.
//

import Foundation
import RxSwift

enum ConfirmModalResult {
    case ok
    case close
}

final class ConfirmModalCoordinator: BasicCoordinator<ConfirmModalResult> {
    var component: ConfirmModalComponent

    init(component: ConfirmModalComponent, navController: UINavigationController) {
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
            .map { ConfirmModalResult.ok }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
