//
//  3__0_HomeCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol HomeResult {}

final class HomeCoordinator: BasicCoordinator<HomeResult> {
    var component: HomeComponent

    init(component: HomeComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {}
}
