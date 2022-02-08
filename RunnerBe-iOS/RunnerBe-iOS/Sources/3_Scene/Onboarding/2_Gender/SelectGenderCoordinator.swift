//
//  SelectGenderCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum SelectGenderResult {}

final class SelectGenderCoordinator: BasicCoordinator<SelectGenderResult> {
    // MARK: Lifecycle

    init(component: SelectGenderComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: SelectGenderComponent

    override func start() {
        navController.pushViewController(component.selectGenderViewController, animated: true)

        component.selectGenderViewModel.routes.nextProcess
            .subscribe(onNext: {
                self.pushSelectJobGroupCoord()
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func pushSelectJobGroupCoord() {
        let selectJobGroupComp = component.selectJobGroupCoord

        let selectJobGroupCoord = SelectJobGroupCoordinator(component: selectJobGroupComp, navController: navController)

        coordinate(coordinator: selectJobGroupCoord)
    }
}
