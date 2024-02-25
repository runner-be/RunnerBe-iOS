//
//  RegisterRunningPaceCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import Foundation
import RxSwift

enum RegisterRunningPaceResult {
    case registeredAndClose
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
        scene.VC.modalPresentationStyle = .overFullScreen
        navigationController.present(scene.VC, animated: animated)
        navigationController = scene.VC

        closeSignal
            .subscribe(onNext: { result in
                switch result {
                case .close, .registeredAndClose:
                    scene.VC.dismiss(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.close
            .map { RegisterRunningPaceResult.close }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.showCompleteModal
            .map { $0 }
            .subscribe(onNext: { pace in
                self.showRegisterConfirmModal(vm: scene.VM, pace: pace)
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.registeredAndClose
            .map { RegisterRunningPaceResult.registeredAndClose }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }

    private func showRegisterConfirmModal(vm: RegisterRunningPaceViewModel, pace: String) {
        let comp = component.confirmModal(pace: pace)
        let coord = ConfirmModalCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord) { [weak self] coordResult in
            switch coordResult {
            case .ok:
                vm.routes.registeredAndClose.onNext(())
            case .close:
                vm.routes.close.onNext(())
            }
        }
    }
}
