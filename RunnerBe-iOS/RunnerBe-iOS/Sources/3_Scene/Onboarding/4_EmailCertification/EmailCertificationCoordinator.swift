//
//  EmailCertificationCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum EmailCertificationResult {}

final class EmailCertificationCoordinator: BasicCoordinator<EmailCertificationResult> {
    // MARK: Lifecycle

    init(component: EmailCertificationComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: EmailCertificationComponent

    override func start() {
        navController.pushViewController(component.emailCertificationViewController, animated: true)
    }
}
