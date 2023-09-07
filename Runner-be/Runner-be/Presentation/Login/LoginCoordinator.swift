//
//  2__LoggedOutCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

enum LoginCoordResult {
    case loginSuccess
}

final class LoginCoordinator: BasicCoordinator<LoginCoordResult> {
    // MARK: Lifecycle

    init(component: LoginComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: LoginComponent

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                defer { scene.VC.removeFromParent() }
                switch result {
                case .loginSuccess:
                    self?.navigationController.popViewController(animated: false)
                }
            })
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.nonMember
            .map { LoginCoordResult.loginSuccess }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.loginSuccess
            .subscribe(onNext: { [weak self] _ in
                self?.closeSignal.onNext(.loginSuccess)
            })
            .disposed(by: sceneDisposeBag)
    }
}
