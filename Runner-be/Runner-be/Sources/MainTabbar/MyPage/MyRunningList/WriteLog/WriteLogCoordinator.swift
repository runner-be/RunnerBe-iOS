//
//  WriteLogCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import UIKit

enum WriteLogResult {
    case backward(Bool)
}

final class WriteLogCoordinator: BasicCoordinator<WriteLogResult> {
    var component: WriteLogComponent

    init(
        component: WriteLogComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: animated)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { WriteLogResult.backward($0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
