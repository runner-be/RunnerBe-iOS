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
    }
}
