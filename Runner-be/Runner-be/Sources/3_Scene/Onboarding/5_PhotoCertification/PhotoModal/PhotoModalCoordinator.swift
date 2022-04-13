//
//  PhotoModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import Foundation
import RxSwift

enum PhotoModalResult {
    case cancel
    case takePhoto
    case choosePhoto
}

final class PhotoModalCoordinator: BasicCoordinator<PhotoModalResult> {
    var component: PhotoModalComponent

    init(component: PhotoModalComponent, navController: UINavigationController) {
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
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { PhotoModalResult.cancel }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.choosePhoto
            .map { PhotoModalResult.choosePhoto }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.takePhoto
            .map { PhotoModalResult.takePhoto }
            .subscribe(closeSignal)
            .disposed(by: disposeBag)
    }
}
