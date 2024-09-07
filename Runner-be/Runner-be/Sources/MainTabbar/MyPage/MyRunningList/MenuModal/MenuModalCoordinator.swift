//
//  MenuModalCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import UIKit

enum MenuModalResult {
    case edit
    case delete
    case backward
}

final class MenuModalCoordinator: BasicCoordinator<MenuModalResult> {
    var component: MenuModalComponent

    init(
        component: MenuModalComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { MenuModalResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.writeLog
            .map { MenuModalResult.edit }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routeInputs.deletedLog
            .map { MenuModalResult.delete }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
