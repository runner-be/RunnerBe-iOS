//
//  BirthCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation
import RxSwift

enum BirthResult {}

final class BirthCoordinator: BasicCoordinator<BirthResult> {
    // MARK: Lifecycle

    init(component: BirthComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: BirthComponent

    override func start() {
        navController.pushViewController(component.birthViewController, animated: true)

//        component.birthViewModel.routes.nextProcess
//            .
    }

    // MARK: Private

    private func pushSelectGenderCoord() {
        let selectGenderComp = component.selectGenderComponent

        let selectGenderCoord = SelectGenderCoordinator(component: selectGenderComp, navController: navController)

        coordinate(coordinator: selectGenderCoord)
    }
}
