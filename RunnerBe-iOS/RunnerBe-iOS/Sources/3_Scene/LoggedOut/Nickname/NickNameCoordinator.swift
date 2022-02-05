//
//  NickNameCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

enum NickNameResult {}

final class NickNameCoordinator: BasicCoordinator<NickNameResult> {
    // MARK: Lifecycle

    init(component: NickNameComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: NickNameComponent

    override func start() {}
}
