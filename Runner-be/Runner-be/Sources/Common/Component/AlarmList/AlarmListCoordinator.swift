//
//  AlarmListCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import Foundation
import RxSwift

enum AlarmListResult {
    case backward
}

final class AlarmListCoordinator: BasicCoordinator<AlarmListResult> {
    var component: AlarmListComponent

    init(component: AlarmListComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .debug()
            .subscribe(onNext: { [weak self] result in
                Log.d(tag: .lifeCycle, "VC poped")
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { AlarmListResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
