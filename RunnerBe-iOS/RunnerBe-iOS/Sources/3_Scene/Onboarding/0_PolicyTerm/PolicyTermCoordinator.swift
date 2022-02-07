//
//  PolicyTermCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import RxSwift

enum PolicyTermResult {}

final class PolicyTermCoordinator: BasicCoordinator<PolicyTermResult> {
    // MARK: Lifecycle

    init(component: PolicyTermComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: PolicyTermComponent

    override func start() {
        navController.pushViewController(component.policyTermViewController, animated: true)

        component.policyTermViewModel.routes.nextProcess
            .subscribe(onNext: {
                self.pushBirthCoord()
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushBirthCoord() {
        let birthComp = component.birthComponent

        let birthCoord = BirthCoordinator(component: birthComp, navController: navController)

        coordinate(coordinator: birthCoord)
    }
}
