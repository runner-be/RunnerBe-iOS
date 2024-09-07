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
            .map { (vm: scene.VM, logForm: $0) }
            .subscribe(onNext: { [weak self] inputs in
                self?.pushWriteLog(
                    vm: inputs.vm,
                    logForm: inputs.logForm,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.confirmLog
            .map { (vm: scene.VM, logForm: $0) }
            .subscribe(onNext: { [weak self] inputs in
                self?.pushConfirmLog(
                    vm: inputs.vm,
                    logForm: inputs.logForm,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.manageAttendance
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] inputs in
                self?.pushManageAttendanceScene(
                    vm: inputs.vm,
                    postId: inputs.postId,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.confirmAttendance
            .map { (vm: scene.VM, postId: $0) }
            .subscribe(onNext: { [weak self] inputs in
                self?.pushConfirmAttendanceScene(
                    vm: inputs.vm,
                    postId: inputs.postId,
                    animated: true
                )
            }).disposed(by: sceneDisposeBag)
    }

    private func pushWriteLog(
        vm: MyRunningListViewModel,
        logForm: LogForm,
        animated: Bool
    ) {
        let comp = component.writeLogComponent(logForm: logForm)
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
        logForm: LogForm,
        animated: Bool
    ) {
        let comp = component.confirmLogComponent(logForm: logForm)
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

    private func pushManageAttendanceScene(
        vm: MyRunningListViewModel,
        postId: Int,
        animated: Bool
    ) {
        let comp = component.manageAttendanceComponent(postId: postId)
        let coord = ManageAttendanceCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }
    }

    private func pushConfirmAttendanceScene(
        vm: MyRunningListViewModel,
        postId: Int,
        animated: Bool
    ) {
        let comp = component.confirmAttendanceComponent(postId: postId)
        let coord = ConfirmAttendanceCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(true)
            }
        }
    }
}
