//
//  SelectJobGroupCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum SelectJobGroupResult {}

final class SelectJobGroupCoordinator: BasicCoordinator<SelectJobGroupResult> {
    // MARK: Lifecycle

    init(component: SelectJobGroupComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SelectJobGroupComponent

    override func start() {
        navController.pushViewController(component.selectJobGroupViewController, animated: true)

        component.selectJobGroupViewModel.routes.nextProcess
            .subscribe(onNext: {
                self.pushEmailCertificationCoord()
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushEmailCertificationCoord() {
        let emailCertificationComp = component.emailCertificationComponent

        let emailCertificationCoord = EmailCertificationCoordinator(component: emailCertificationComp, navController: navController)

        coordinate(coordinator: emailCertificationCoord)
    }
}
