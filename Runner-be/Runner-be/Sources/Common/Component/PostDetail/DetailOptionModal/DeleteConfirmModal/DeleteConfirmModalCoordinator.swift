//
//  DeleteConfirmModalCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/08.
//

import Foundation
import RxSwift

enum DeleteConfirmModalResult {
    case delete
    case cancel
}

final class DeleteConfirmModalCoordinator: BasicCoordinator<DeleteConfirmModalResult> {
    var component: DeleteConfirmModalComponent

    init(component: DeleteConfirmModalComponent, navController: UINavigationController) {
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
            .routes.cancel
            .map { DeleteConfirmModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.signout
            .map { DeleteConfirmModalResult.delete }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
