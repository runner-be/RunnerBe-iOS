//
//  WritingPostCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import Foundation
import RxSwift

enum WritingPostResult {}

final class WritingPostCoordinator: BasicCoordinator<WritingPostResult> {
    var component: WritingPostComponent

    init(component: WritingPostComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)
    }
}
