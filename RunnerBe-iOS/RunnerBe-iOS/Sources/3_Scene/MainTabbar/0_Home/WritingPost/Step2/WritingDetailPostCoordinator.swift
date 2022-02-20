//
//  WritingDetailPostCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import Foundation
import RxSwift

enum WritingDetailPostResult {}

final class WritingDetailPostCoordinator: BasicCoordinator<WritingDetailPostResult> {
    var component: WritingDetailPostComponent

    init(component: WritingDetailPostComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)
    }
}
