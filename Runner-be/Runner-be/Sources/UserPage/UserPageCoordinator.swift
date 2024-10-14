//
//  UserPageCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 10/14/24.
//

import UIKit

enum UserPageResult {
    case backward
}

final class UserPageCoordinator: BasicCoordinator<UserPageResult> {
    var component: UserPageComponent

    init(
        component: UserPageComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: animated)
                }

            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { UserPageResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
