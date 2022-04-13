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

    override func start(animated: Bool = true) {
        let scene = component.scene
        if component.isModal {
            scene.VC.modalPresentationStyle = .overCurrentContext
            scene.VC.modalTransitionStyle = .coverVertical
            navigationController.present(scene.VC, animated: animated)
        } else {
            navigationController.pushViewController(scene.VC, animated: animated)
        }

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.component.isModal {
                    scene.VC.dismiss(animated: true)
                } else {
                    self.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)

        scene.VM.routes.close
            .map { PolicyDetailResult.close }
            .bind(to: closeSignal)
            .disposed(by: disposeBag)
    }
}
