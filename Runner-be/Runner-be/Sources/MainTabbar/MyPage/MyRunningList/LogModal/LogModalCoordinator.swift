//
//  LogModalCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import Foundation

import UIKit

enum LogModalResult {
    case backward
    case agree
}

final class LogModalCoordinator: BasicCoordinator<LogModalResult> {
    var component: LogModalComponent

    init(
        component: LogModalComponent,
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
            .map { LogModalResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.tapOK
            .map { LogModalResult.agree }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
