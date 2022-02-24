//
//  PostDetailCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import RxSwift

enum PostDetailResult {
    case backward
}

final class PostDetailCoordinator: BasicCoordinator<PostDetailResult> {
    var component: PostDetailComponent

    init(component: PostDetailComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)
    }
}
