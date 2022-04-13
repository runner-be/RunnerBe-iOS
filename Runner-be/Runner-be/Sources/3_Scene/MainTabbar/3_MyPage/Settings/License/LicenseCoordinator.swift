//
//  LicenseCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//
import Foundation
import RxSwift

enum LicenseResult {
    case backward
}

final class LicenseCoordinator: BasicCoordinator<LicenseResult> {
    var component: LicenseComponent

    init(component: LicenseComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal.subscribe(onNext: { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        })
        .disposed(by: disposeBag)

        scene.VM.routes.backward
            .map { LicenseResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
