//
//  LogoutModalCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//
import UIKit

enum LogoutModalResult {
    case backward
    case logout
}

final class LogoutModalCoordinator: BasicCoordinator<LogoutModalResult> {
    var component: LogoutModalComponent

    init(component: LogoutModalComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: false)
            })
            .disposed(by: disposeBag)

        scene.VM
            .routes.backward
            .map { LogoutModalResult.backward }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM
            .routes.logout
            .map { LogoutModalResult.logout }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
