//
//  WaitCertificationCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import Foundation
import RxSwift

enum WaitCertificationResult {}

final class WaitCertificationCoordinator: BasicCoordinator<WaitCertificationResult> {
    var component: WaitCertificationComponent

    init(component: WaitCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {
        let scene = component.scene
        navController.pushViewController(scene.VC, animated: true)
    }
}
