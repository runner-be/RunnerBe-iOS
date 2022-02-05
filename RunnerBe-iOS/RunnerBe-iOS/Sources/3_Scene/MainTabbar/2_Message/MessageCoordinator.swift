//
//  3__2_MessageCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol MessageResult {}

final class MessageCoordinator: BasicCoordinator<MessageResult> {
    // MARK: Lifecycle

    init(component: MessageComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: MessageComponent

    override func start() {}
}
