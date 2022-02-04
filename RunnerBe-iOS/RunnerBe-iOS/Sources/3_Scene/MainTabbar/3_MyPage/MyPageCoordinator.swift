//
//  3__3_MyPageCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol MyPageResult {}

final class MyPageCoordinator: BasicCoordinator<MyPageResult> {
    var component: MyPageComponent

    init(component: MyPageComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start() {}
}
