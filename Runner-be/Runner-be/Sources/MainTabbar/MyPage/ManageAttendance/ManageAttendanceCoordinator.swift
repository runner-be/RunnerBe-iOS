//
//  ManageAttendanceCordinator.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import Foundation
import RxSwift

enum ManageAttendanceResult {
//    case s
    case backward
}

final class ManageAttendanceCoordinator: BasicCoordinator<ManageAttendanceResult> {
    var component: ManageAttendanceComponent

    init(component: ManageAttendanceComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { ManageAttendanceResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
