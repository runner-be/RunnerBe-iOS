//
//  3__1_BookMarkCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import RxSwift

protocol BookMarkResult {}

final class BookMarkCoordinator: BasicCoordinator<BookMarkResult>
{
    // MARK: Lifecycle

    init(component: BookMarkComponent, navController: UINavigationController)
    {
        self.component = component
        super.init(navController: navController)
    }

    // MARK: Internal

    var component: BookMarkComponent

    override func start() {}
}
