//
//  ImageViewerCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 7/11/24.
//

import UIKit

enum ImageViewerResult {
    case backward
}

final class ImageViewerCoordinator: BasicCoordinator<ImageViewerResult> {
    var component: ImageViewerComponent

    init(
        component: ImageViewerComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .fullScreen
        scene.VC.modalTransitionStyle = .crossDissolve
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: true)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { ImageViewerResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
