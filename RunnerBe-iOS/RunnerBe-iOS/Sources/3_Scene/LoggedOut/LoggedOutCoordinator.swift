//
//  2__LoggedOutCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

enum LoggedOutResult {
    case loginSuccess(isCertificated: Bool)
}

final class LoggedOutCoordinator: BasicCoordinator<LoggedOutResult> {
    // MARK: Lifecycle

    init(component: LoggedOutComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: LoggedOutComponent

    override func start() {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: false)

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
            .subscribe(onNext: { [weak self] in
                self?.pushPolicyTerm()
            })
            .disposed(by: disposeBag)

        scene.VM.routes.loginSuccess
            .subscribe(onNext: { [weak self] isCertificated in
                self?.closeSignal.onNext(.loginSuccess(isCertificated: isCertificated))
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushPolicyTerm() {
        let comp = component.policyTermComponent
        let coord = PolicyTermCoordinator(component: comp, navController: navController)

        let disposable = coordinate(coordinator: coord)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.release(coordinator: coord)
            })

        addChildBag(id: coord.id, disposable: disposable)
    }
}
