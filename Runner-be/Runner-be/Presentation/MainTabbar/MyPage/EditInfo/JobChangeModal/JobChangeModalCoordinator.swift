//
//  JobChangeModalCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//

import UIKit

enum JobChangeModalResult {
    case cancel
    case ok
}

final class JobChangeModalCoordinator: BasicCoordinator<JobChangeModalResult> {
    var component: JobChangeModalComponent

    init(component: JobChangeModalComponent, navController: UINavigationController) {
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
            .map { JobChangeModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.ok
            .debug()
            .map { JobChangeModalResult.ok }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
