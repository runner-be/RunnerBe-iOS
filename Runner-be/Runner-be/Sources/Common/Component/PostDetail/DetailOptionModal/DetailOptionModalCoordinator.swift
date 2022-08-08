//
//  DetailOptionModalCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import UIKit

enum DetailOptionModalResult {
    case cancel
    case delete
}

final class DetailOptionModalCoordinator: BasicCoordinator<DetailOptionModalResult> {
    var component: DetailOptionModalComponent

    init(component: DetailOptionModalComponent, navController: UINavigationController) {
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
            .map { DetailOptionModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.delete
            .debug()
            .map { DetailOptionModalResult.delete }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
