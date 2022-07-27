//
//  RunningTagModalCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/07/27.
//

import UIKit

enum RunningTagModalResult {
    case cancel
    case ok(tag: RunningTag)
}

final class RunningTagModalCoordinator: BasicCoordinator<RunningTagModalResult> {
    var component: RunningTagModalComponent

    init(component: RunningTagModalComponent, navController: UINavigationController) {
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
            })
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.backward
            .debug()
            .map { RunningTagModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.ok
            .debug()
            .map { RunningTagModalResult.ok(tag: $0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
