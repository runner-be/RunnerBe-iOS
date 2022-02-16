//
//  HomeFilterCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import Foundation
import RxSwift

enum HomeFilterResult {}

final class HomeFilterCoordinator: BasicCoordinator<HomeFilterResult> {
    var component: HomeFilterComponent

    init(component: HomeFilterComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)
    }
}
