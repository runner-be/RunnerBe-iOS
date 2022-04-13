//
//  ReportModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/05.
//

import UIKit

enum ReportModalResult {
    case cancel
    case ok
}

final class ReportModalCoordinator: BasicCoordinator<ReportModalResult> {
    var component: ReportModalComponent

    init(component: ReportModalComponent, navController: UINavigationController) {
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
            .routes.backward
            .debug()
            .map { ReportModalResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM
            .routes.ok
            .debug()
            .map { ReportModalResult.ok }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
