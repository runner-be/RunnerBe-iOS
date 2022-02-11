//
//  PolicyDetailCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum PolicyDetailResult {
    case close
}

final class PolicyDetailCoordinator: BasicCoordinator<PolicyDetailResult> {
    var component: PolicyDetailComponent

    init(component: PolicyDetailComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        scene.VC.modalTransitionStyle = .coverVertical
        navController.present(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { _ in
                scene.VC.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        scene.VM.routes.close
            .map { PolicyDetailResult.close }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
