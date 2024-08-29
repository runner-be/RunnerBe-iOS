//
//  MyRunningListCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/29/24.
//

import UIKit

enum MyRunningListResult {
    case backward
}

final class MyRunningListCoordinator: BasicCoordinator<MyRunningListResult> {
    var component: MyRunningListComponent

    init(
        component: MyRunningListComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { MyRunningListResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
