//
//  1_AppCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxSwift
import UIKit

final class AppCoordinator: BasicCoordinator<Void> {
    override func start() {
        navController.pushViewController(LoggedOutViewController(viewModel: LoggedOutViewModel()), animated: false)
    }

    func showMain() {}

    func showLoggedOut() {}
}
