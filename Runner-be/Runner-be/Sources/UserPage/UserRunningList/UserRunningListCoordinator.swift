//
//  UserRunningListCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import Foundation
import UIKit

enum UserRunningListResult {
    case backward
}

final class UserRunningListCoordinator: BasicCoordinator<UserRunningListResult> {
    var component: UserRunningListComponent

    init(
        component: UserRunningListComponent,
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
            .map { UserRunningListResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] result in
                self?.pushDetailPostScene(vm: result.vm, postId: result.postId, animated: true)
            })
            .disposed(by: sceneDisposeBag)
    }

    func pushDetailPostScene(vm: UserRunningListViewModel, postId: Int, animated: Bool) {
        let comp = component.postDetailComponent(postId: postId)
        let coord = PostDetailCoordinator(component: comp, navController: navigationController)

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(_, needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }
}
