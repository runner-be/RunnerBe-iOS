//
//  SettingsCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxSwift

enum SettingsResult {
    case backward
}

final class SettingsCoordinator: BasicCoordinator<SettingsResult> {
    var component: SettingsComponent

    init(component: SettingsComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { SettingsResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
