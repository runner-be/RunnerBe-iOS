//
//  ManageTimeExpiredModalCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//
import Foundation
import RxSwift

enum ManageTimeExpiredModalResult {
    case ok
}

final class ManageTimeExpiredModalCoordinator: BasicCoordinator<ManageTimeExpiredModalResult> {
    var component: ManageTimeExpiredModalComponent

    init(component: ManageTimeExpiredModalComponent, navController: UINavigationController) {
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

        scene.VM.routes.ok
            .debug()
            .map { ManageTimeExpiredModalResult.ok }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
