//
//  MyRunningListCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/29/24.
//

import UIKit

enum MyRunningListResult {
    case backward
}

final class MyRunningListCoordinator: BasicCoordinator<MyRunningListResult> {
    var component: MyRunningListComponent

    init(
        component: MyRunningListComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { MyRunningListResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.writeLog
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] inputs in
                self?.pushWriteLog(
                    vm: inputs.vm,
                    postId: inputs.postId,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.confirmLog
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] inputs in
                self?.pushConfirmLog(
                    vm: inputs.vm,
                    postId: inputs.postId,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)
    }

    private func pushWriteLog(
        vm: MyRunningListViewModel,
        postId: Int,
        animated: Bool
    ) {
        let comp = component.writeLogComponent(postId: postId)
        let coord = WriteLogCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }

    private func pushConfirmLog(
        vm: MyRunningListViewModel,
        postId: Int,
        animated: Bool
    ) {
        let comp = component.writeLogComponent(postId: postId)
        let coord = ConfirmLogCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }
}
