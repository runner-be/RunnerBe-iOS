//
//  WriteLogCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import UIKit

enum WriteLogResult {
    case backward(Bool)
}

final class WriteLogCoordinator: BasicCoordinator<WriteLogResult> {
    var component: WriteLogComponent

    init(
        component: WriteLogComponent,
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
            .map { WriteLogResult.backward($0) }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.logStampBottomSheet
            .map { (vm: scene.VM, selectedLogStamp: $0) }
            .bind { [weak self] inputs in
                self?.pushLogStampBottomSheetScene(
                    vm: inputs.vm,
                    selectedLogStamp: inputs.selectedLogStamp,
                    animated: false
                )
            }.disposed(by: sceneDisposeBag)
    }

    private func pushLogStampBottomSheetScene(
        vm: WriteLogViewModel,
        selectedLogStamp: LogStamp2,
        animated: Bool
    ) {
        let comp = component.logStampBottomSheetComponent(selectedLogStamp: selectedLogStamp)
        let coord = LogStampBottomSheetCoordinator(
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
            case let .apply(logStamp):
                vm.routeInputs.selectedLogStamp.onNext(logStamp)
            }
        }
    }
}
