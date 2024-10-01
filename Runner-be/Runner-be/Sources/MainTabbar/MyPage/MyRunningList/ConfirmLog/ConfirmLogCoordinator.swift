//
//  ConfirmLogCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import UIKit

enum ConfirmLogResult {
    case backward(Bool)
}

final class ConfirmLogCoordinator: BasicCoordinator<ConfirmLogResult> {
    var component: ConfirmLogComponent

    init(
        component: ConfirmLogComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: animated)
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.backward
            .map { ConfirmLogResult.backward($0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.modal
            .bind { [weak self] _ in
                self?.showMenuModalScene(
                    vm: scene.VM,
                    animated: false
                )
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.writeLog
            .bind { [weak self] logForm in
                self?.pushWriteLogScene(
                    logForm: logForm,
                    writeLogMode: .edit,
                    vm: scene.VM,
                    animated: true
                )
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.newConfirmLog
            .bind { [weak self] logId in
                self?.pushNewConfirmLogScene(
                    logId: logId,
                    vm: scene.VM,
                    animated: true
                )
            }.disposed(by: sceneDisposeBag)

        scene.VM.routes.togetherRunner
            .map { (vm: scene.VM, gatheringId: $0) }
            .bind { [weak self] inputs in
                self?.pushTogetherRunnerScene(
                    vm: inputs.vm,
                    gatheringId: inputs.gatheringId,
                    animated: true
                )
            }.disposed(by: sceneDisposeBag)
    }

    private func showMenuModalScene(
        vm: ConfirmLogViewModel,
        animated: Bool
    ) {
        let comp = component.menuModalComponent
        let coord = MenuModalCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .edit:
                vm.routeInputs.editLog.onNext(())
            case .delete:
                vm.routeInputs.deleteLog.onNext(())
            case .backward:
                print("모달을 종료합니다.")
            }
        }
    }

    private func pushWriteLogScene(
        logForm: LogForm,
        writeLogMode: WriteLogMode,
        vm: ConfirmLogViewModel,
        animated: Bool
    ) {
        let comp = component.writeLogComponent(
            logForm: logForm,
            writeLogMode: writeLogMode
        )
        let coord = WriteLogCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }

    private func pushNewConfirmLogScene(
        logId: Int,
        vm: ConfirmLogViewModel,
        animated: Bool
    ) {
        let comp = component.newConfirmLogComponent(logId: logId)
        let coord = ConfirmLogCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case let .backward(needUpdate):
                vm.routeInputs.needUpdate.onNext(needUpdate)
            }
        }
    }

    private func pushTogetherRunnerScene(
        vm _: ConfirmLogViewModel,
        gatheringId: Int,
        animated: Bool
    ) {
        let comp = component.togetherRunnerComponent(gatheringId: gatheringId)
        let coord = TogetherRunnerCoordinator(
            component: comp,
            navController: navigationController
        )

        coordinate(
            coordinator: coord,
            animated: animated
        ) { coordResult in
            switch coordResult {
            case .backward:
                break
            }
        }
    }
}
