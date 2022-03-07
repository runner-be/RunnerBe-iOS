//
//  2__LoggedOutCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

enum LoggedOutResult {
    case loginSuccess
}

final class LoggedOutCoordinator: BasicCoordinator<LoggedOutResult> {
    // MARK: Lifecycle

    init(component: LoggedOutComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: LoggedOutComponent

    override func start(animated: Bool = true) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                defer { scene.VC.removeFromParent() }
                switch result {
                case .loginSuccess:
                    self?.navController.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.nonMember
            .map { LoggedOutResult.loginSuccess }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)

        scene.VM.routes.loginSuccess
            .subscribe(onNext: { [weak self] _ in
                self?.closeSignal.onNext(.loginSuccess)
            })
            .disposed(by: disposeBag)
    }
}
