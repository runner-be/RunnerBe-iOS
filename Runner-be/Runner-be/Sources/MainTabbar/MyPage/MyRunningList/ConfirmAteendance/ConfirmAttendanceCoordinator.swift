//
//  ConfirmAttendanceCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

enum ConfirmAttendanceResult {
    case backward
}

final class ConfirmAttendanceCoordinator: BasicCoordinator<ConfirmAttendanceResult> {
    var component: ConfirmAttendanceComponent

    init(
        component: ConfirmAttendanceComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: animated)
                }

            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { ConfirmAttendanceResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
