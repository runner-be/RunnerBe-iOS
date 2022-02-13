//
//  2__LoggedOutCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import RxSwift

enum LoggedOutResult {}

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

        scene.VM.routes.nonMember
            .subscribe(onNext: {
                self.pushPolicyTerm()
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushPolicyTerm() {
        let policyComp = component.policyTermComponent

        let policyCoord = PolicyTermCoordinator(component: policyComp, navController: navController)
        let uuid = policyCoord.id

        let disposable = coordinate(coordinator: policyCoord)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.release(coordinator: policyCoord)
            })

        childBags[uuid, default: []].append(disposable)
    }
}
