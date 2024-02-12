//
//  RegisterRunningPaceCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import Foundation
import RxSwift

enum RegisterRunningPaceResult {
    case close
}

final class RegisterRunningPaceCoordinator: BasicCoordinator<RegisterRunningPaceResult> {
    var component: RegisterRunningPaceComponent

    init(component: RegisterRunningPaceComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .fullScreen
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .close:
                    self?.navigationController.dismiss(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.close
            .map { RegisterRunningPaceResult.close }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
