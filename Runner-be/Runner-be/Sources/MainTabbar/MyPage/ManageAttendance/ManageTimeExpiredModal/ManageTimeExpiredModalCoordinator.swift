//
//  ManageTimeExpiredModalCoordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//
import Foundation
import RxSwift

enum ManageTimeExpiredModalResult {
//    case s
    case ok
}

final class ManageTimeExpiredModalCoordinator: BasicCoordinator<ManageTimeExpiredModalResult> {
    var component: ManageTimeExpiredModalComponent

    init(component: ManageTimeExpiredModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

//        closeSignal
//            .subscribe(onNext: { [weak self] result in
//                switch result {
//                case .ok:
//                    self?.navigationController.popViewController(animated: true)
//                }
//            })
//            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.ok
//            .map { ManageAttendanceResult.backward }
//            .bind(to: closeSignal)
//            .disposed(by: sceneDisposeBag)
    }
}
