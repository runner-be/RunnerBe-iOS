//
//  TakePhotoModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

enum TakePhotoModalResult {
    case cancel
    case takePhoto
    case choosePhoto
}

final class TakePhotoModalCoordinator: BasicCoordinator<TakePhotoModalResult> {
    var component: TakePhotoModalComponent

    init(component: TakePhotoModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM
            .routes.backward
            .map { TakePhotoModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM
            .routes.choosePhoto
            .map { TakePhotoModalResult.choosePhoto }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM
            .routes.takePhoto
            .map { TakePhotoModalResult.takePhoto }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
